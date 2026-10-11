
import { BaseItem1 } from "../common/BaseItem1"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Vector3 } from "../util/Vector3"
import { Config } from "../common/Config"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { ResManager } from "../common/ResManager"
import { ErlangParser } from "../util/ErlangParser"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"

export class DungeonTowerItem extends BaseItem1 {

    //因为每个item都是循环使用的  需要有一个唯一id
    item_id

    InitView
    data
    need_fresh
    SetCusScale

    PlayAnimation
    is_play
    tween_id
    model
    reward_item: BaseAwardItem

    UpdateSelect
    GetDataIdx

    //单元记忆当前选中的idx和item_id 便于循环是刷新item
    record_idx
    record_item_id

    public constructor(parent?) {
        super(parent)

        this.base_file = "dungeonTower"
        this.layout_file = "DungeonTowerItem"
        this.layer_value = "UI"
        this.need_fresh = false
        this.is_play = false
        this.tween_id = null
        this.reward_item = null
        this.model = BaseDungeonModel.GetInstance()
        this.load_callback = () => {
            this._box_pos.scale(0, 0)

            this.InitView()

            if (this.need_fresh) {
                this.need_fresh = false
                this.SetData(this.data)
            }


            if (this.is_play) {
                this.is_play = false
                this.PlayAnimation()
            }

           
        }

        this.InitView = () => {
            this.BindEvent(this.model, BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_SELECT, (idx?,item_id?) => {
                this.record_idx=idx
                this.record_item_id=item_id
                this.UpdateSelect()
            })



            Util.AddClickEvent(this._box_pos, () => {
                if(!this.data)return
                this.model.Fire(BaseDungeonModel.LIMIT_TIME_TOWER_ITEM_SELECT,this.data.idx,this.item_id)
            }, this, false)
    

        }

        this.UpdateSelect=()=>{

            if (this.record_idx!=null&&this.record_item_id!=null&&
                this.data && this.record_idx == this.data.idx&&this.item_id==this.record_item_id) {
                this._img_select.visible=true
            }else{
                this._img_select.visible=false
            }
        }

        //缩放
        let range_scale = [37.5, 112.5]
        this.SetCusScale = (cur_y, min_y, max_y) => {
            let p = cur_y / (max_y - min_y)  //百分数   
            let scale = (range_scale[0] + p * (range_scale[1] - range_scale[0])) / 100
            this.SetScale(scale)
        }

        //播放生成动画
        this.PlayAnimation = () => {
            if (!this.is_loaded) {
                this.is_play = true
                return
            }

            if (this.tween_id) {
                SYTweenLite.Stop(this.tween_id)
                this.tween_id = null
            }


            this._box_pos.scale(0, 0)
            this.tween_id = SYTweenLite.to(this.display_obj, this._box_pos, SYTweenLite.UiAnimationType.SCALE, new Vector3(1, 1, 1),
                0.4, null, SYTweenFunc.EASE_OUT_BACK)

        }


    }



    
    public SetData(data) {
        this.data = data
        if (this.is_loaded) {
            if (this.data == null) {
                this._lb_title.text = `ID:${this.item_id}`
                return
            }
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon
            let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, this.data.dun_id, false, cfg)
            this._lb_title.text = `第${this.data.idx}关`


            let is_pass = this.model.CheckTowerIsPass(this.data.dun_id)
            this._img_got.visible = is_pass
            //this._img_select.visible = !is_pass
            if (this.data.is_max) {
                ResManager.GetInstance().SetImageSprite(this, this._img1, "dungeonTower", "ui_copy_89")
                this._img1.size(184, 252)
                this._img1.pos(87, 262)

                ResManager.GetInstance().SetImageSprite(this, this._img_select, "dungeonTower", "ui_copy_89a")
                this._img_select.size(184, 252)
                this._img_select.pos(87, 262)

                ResManager.GetInstance().SetImageSprite(this, this._img_titile, "dungeonTower", "ui_copy_92")
            } else {
                ResManager.GetInstance().SetImageSprite(this, this._img1, "dungeonTower", "ui_copy_91")
                this._img1.size(176, 266)
                this._img1.pos(87, 268)

                ResManager.GetInstance().SetImageSprite(this, this._img_select, "dungeonTower", "ui_copy_90")
                this._img_select.size(176, 266)
                this._img_select.pos(87, 268)

                ResManager.GetInstance().SetImageSprite(this, this._img_titile, "dungeonTower", "ui_copy_93")
            }


            //奖励
            let config_dun_reward = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
            if (config_dun_reward) {
                //关卡所有奖励
                let rewards = this.model.GetTowerRewards(this.data.dun_id, config_dun_reward)
                if (rewards && rewards.length > 0) {
                    let first_item = rewards[0]
                    if (!this.reward_item) {
                        this.reward_item = new BaseAwardItem(this._box_reward)
                        this.reward_item.SetItemSize(89, 89)
                        this.reward_item.SetShowTips(false)
                        this.reward_item.Load()
                    }

                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(first_item[0], first_item[1])
                    let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                    if (vo) {
                        this.reward_item.SetData(type_id, first_item[2])
                    }
                }

            }

            this.UpdateSelect()

        } else {
            this.need_fresh = true
        }

        this.GetDataIdx=()=>{
            if(this.data)return this.data.idx
            return -1
        }
    }
    
    /**设置一个唯一id 初始化的时候赋值 */
    public SetID(item_id){
        this.item_id=item_id
    }

    public DeleteMe() {
        if (this.tween_id) {
            SYTweenLite.Stop(this.tween_id)
            this.tween_id = null
        }
        if (this.reward_item) {
            this.reward_item.DeleteMe()
            this.reward_item = null
        }
        super.DeleteMe()
    }


    _box_pos: Laya.Box
    _img_titile: Laya.Image
    _lb_title: Laya.Label
    _img1: Laya.Image
    _img_select: Laya.Image
    _box_reward: Laya.Box
    _img_got: Laya.Image
    public GetComponents() {
        [
            this._box_pos,
            this._img_titile,
            this._lb_title,
            this._img1,
            this._img_select,
            this._box_reward,
            this._img_got,
        ]
            = this.GetChildrenByNames([

                "_box_pos",
                "_img_titile",
                "_lb_title",
                "_img1",
                "_img_select",
                "_box_reward",
                "_img_got",
            ])
    }
}
window["DungeonTowerItem"] = DungeonTowerItem