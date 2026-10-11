import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { FashionModel } from "../commonModel/FashionModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"


let local_FashionModel = FashionModel
export class FashionSuitGoodsItem extends BaseItem1 {

    model: FashionModel = local_FashionModel.GetInstance()
    equip_item:EquipmentItem
    need_refresh_data
    data
    public constructor(parent?) {
        super(parent)
        this.base_file = "fashion"
        this.layout_file = "FashionSuitGoodsItem"
        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess = () => {

        this.equip_item = new EquipmentItem(this._box_con)
        this.equip_item.Load()
        this.equip_item.SetItemSize(85)

        this.InitEvent()

        if(this.need_refresh_data){
            this.UpdateItem()
        }
    }

    public InitEvent(){
        Util.AddClickEvent(this._box_con, ()=>{

        }, this, true)

        this.BindEvent(this.model, FashionModel.GETACTIVATEFASHION, () => {
            let type = this.data && this.data[0]
            if(type == 1){
                this.UpdateItem()
            }
        })

        this.BindEvent(this.model, FashionModel.UPDATEVIEW, (pos_id) => {
            if(!pos_id) return
            let type = this.data && this.data[0]
            if(type == 1){
                if(Number(this.data[1]) == Number(pos_id)){
                    this.UpdateItem()
                }
            }
        })


        // this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_OUTWARD_DATA, (data) => {
        //     let type = this.data && this.data[0]
        //     if(type == 2){
        //         if(Number(this.data[1]) == Number(data.type_id)){
        //             this.UpdateItem()
        //         }
        //     }
        // })

        this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_OUTWARD_ILLUSION_VIEW, (data) => {
            let type = this.data && this.data[0]
            if(type == 2){
                if(Number(this.data[1]) == Number(data.type_id)){
                    this.UpdateItem()
                }
            }
        })
    }


    public SetData(data){
        this.data = data
        if(this.is_loaded){
            this.UpdateItem()
        }
        else{
            this.need_refresh_data = true
        }
    }

    public UpdateItem(){
        let data = this.data
        let career = RoleManager.GetInstance().GetMainRoleCareer(),
            sex = RoleManager.GetInstance().GetMainRoleSex()

        let type = data[0],
            sub_type = data[1],
            id = data[2]


        let stage = this.model.GetSuitLvPosByVo(data)
        if(type == 1){/**时装 */
            /**时装id和物品id一致 */
            let key = `${sub_type}@${id}@${career}@${sex}@0`
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_model[key]
            this.equip_item.SetData(cfg.fashion_id)

            if(stage >= 0){
                this.equip_item.SetGary(false)
                this.equip_item.SetGrade(stage)
            }
            else{
                this.equip_item.SetGary(true)
                this.equip_item.SetGrade(0)
            }
        } else if(type == 2){/**培养幻化 */
            let key = `${sub_type}@${id}@${career}`
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_figure[key]
            let goods_id = cfg.goods_id

            //和策划约定好判断如果是碎片就替换成实际物品
            let len = String(goods_id).length
            let n = String(goods_id).slice(len-3, len-2)
            if(n == "1"){
                goods_id -= 100
            }

            this.equip_item.SetData(goods_id)

            if(stage >= 0){
                //如果不是坐骑和侍魂，为了和培养功能那边对应，展示的阶数要减1
                if(sub_type != 1 && sub_type != 2){
                    stage-=1
                }

                this.equip_item.ExcuteCallback(()=>{
                    this.equip_item.SetGary(false)
                    this.equip_item.SetGrade(stage, "星", true)
                })
            }
            else{
                this.equip_item.SetGary(true)
                this.equip_item.SetGrade(0)
            }

        }
    }

    public DeleteMe() {
        if(this.equip_item){
            this.equip_item.DeleteMe()
            this.equip_item = undefined
        }
        super.DeleteMe()
    }


    _box_con: Laya.Box
    public GetComponents() {
        [
            this._box_con,
        ]
            = this.GetChildrenByNames([

                "_box_con",
            ])
    }
}
window["FashionSuitGoodsItem"] = FashionSuitGoodsItem