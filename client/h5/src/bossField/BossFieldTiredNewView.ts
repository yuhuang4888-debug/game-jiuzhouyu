import { BaseView1, OpenMode } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, RefBoxVLayout, SetHtmlStyle, Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { MaterialsTool } from "../common/MaterialsTool"
import { Alert, Alert_Type } from "../alert/Alert"
import { BossSceneEvent, BossSceneManager } from "../commonController/BossSceneManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { Config } from "../common/Config"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"
export class BossFieldTiredNewView extends BaseView1 {
    model: BossModel
    goods_model: GoodsModel
    reward_item:EquipmentItem
    time_id: any
    tried_goods_id = 38160001
    have_goods = false
    SetPower
    str_p
    str_p2
    boss_vo
    public constructor() {
        super()


        this.base_file = "bossField"
        this.layout_file = "BossFieldTiredNewView"
        this.layer_value = Enum_UILayer.Activity
        this.open_mode = OpenMode.OpenToggle
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.back_login_toClose = true
        this.model = BossModel.GetInstance()
        this.goods_model = GoodsModel.GetInstance()
        this.boss_vo = null
        this.preload_server_config = {
            "config_boss_type_key_value": false,
            "config_num_by_vip": false
        }
        this.load_callback = () => {
            SetHtmlStyle(this.tired, { c: "#d15e00", f: 20, w: 300, ww: false })
            SetHtmlStyle(this.tired_tip, { c: "#663915", f: 20, w: 300, ww: false })
            SetHtmlStyle(this._lb_time, { c: "#663915", f: 20, w: 300, ww: false })
            this.tired.style.bold = true
            this.tired_tip.style.bold = true
            this._lb_time.style.bold = true
            this.tired_tip.visible = this.boss_vo != null && this.boss_vo.reborn_time == 0
            if (this.boss_vo != null && this.boss_vo.reborn_time == 0) {
                let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.boss_vo.boss_id, false)
                let boss_info = HtmlColorTxt(`${this.boss_vo.boss_name}&nbsp;Lv.${this.boss_vo.lv}`, Enum_ColorUtil_Dark.ORANGE)
                this.tired_tip.innerHTML = `击杀[${boss_info}]需消耗体力：${HtmlColorTxt(this.boss_vo.tired_add + "", Enum_ColorUtil_Dark.GREEN)}`
            }

            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
            let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfg)
            let beishu = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? 0.8 : 1
            let all_time = time * beishu

            let m = Math.floor(all_time / 60);
            let color_str = HtmlColorTxt(m, '"#0a953e"')
            this.str_p = HtmlColorTxt(`(${color_str}分钟回复一点体力)`, '"#663915"')
            this.str_p2 = HtmlColorTxt(`当前体力值：`, '"#663915"')
            this.LoadSuccess()
            this.InitEvent()

            RefBoxVLayout(this._box_info, 15, true)
        }

        this.close_callback = () => {
            if (this.reward_item) {
                this.reward_item.DeleteMe()
                this.reward_item = null
            }
            this.ClearTimer()
        }


        this.SetPower = (now, max) => {
            if (now >= max) {
                this.tired.innerHTML = `${this.str_p2}${now}/${max}`
            } else {
                this.tired.innerHTML = `${this.str_p2}${now}/${max}${this.str_p}`
            }

        }
    }

    InitEvent = () => {
        this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_VIT_TIME, (scmd/**vit?, max_vit?, last_vit_time?*/) => {
            this.ShowVit(scmd.vit, scmd.max_vit, scmd.last_vit_time,scmd.add_vit)
            this.SetGoods()
            this.SetVip()
            this.SetPower(scmd.vit, scmd.max_vit)
        }
        )
        BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)

        Util.AddClickEvent(this.close, () => {
            this.Close()
        }, true)
        Util.AddClickEvent(this.use, () => {

            if (this.have_goods) {
                let goods_id = this.goods_model.GetOneGoodsByTypeId(BossModel.tired_goods_id)
                let info = this.model.GetBossTypeInfo(BossModel.BossType.field)
                let tired = info.tired
                let all_tired = info.all_tired
                if (all_tired - tired >= 1)
                    this.goods_model.Fire(GoodsModel.USE_BAG_GOODS, goods_id, 1)
                else
                    Alert.Show("使用体力秘药将会超过体力上限。<br/>是否确认使用？", Alert_Type.Two, () => {
                        this.goods_model.Fire(GoodsModel.USE_BAG_GOODS, goods_id, 1)
                    })
            }
            else {
                MaterialsTool.GetInstance().materialsTips(BossModel.tired_goods_id)
            }
            //this.Close()
        }, true)
        Util.AddClickEvent(this.go, () => {
            let mine_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag

            let open_id = mine_vip >= 4 ? 66 : 8
            OpenFun.OpenFunHandler(open_id)
            this.Close()
        }, true)
        //更新疲劳
        this.BindEvent(BossSceneManager.GetInstance(), BossSceneEvent.TIRED_DATA_UPDATE, (boss_tired, boss_type) => {
            let dataList = BossModel.GetInstance().GetBossTypeInfo(BossModel.BossType.field)
            if (dataList)
                dataList.tired = boss_tired
        })


        this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (list?) => {
            if (this.use_delete_method) {
                return
            }
            for (let _tmpi in list) {
                var v = list[_tmpi]
                if ( v.type_id == this.tried_goods_id) {
                    this.SetGoods()
                }
            }
        }
        )

    }

    LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("bossField", "ui_chief_32"), true)
        let info = this.model.GetBossTypeInfo(BossModel.BossType.field)
        this.SetPower(info.tired, info.all_tired)
        this.SetGoods()
        this.SetVip()
    }



    cur_vit =0//防止无限刷新
	req_vit = -1 //请求更新时的vit
	last_vit_time = 0 


    public ShowVit(vit?, max_vit?, last_vit_time?,add_vit?) {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
        let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfg)
        //每天最多恢复的体力上限
        let add_vit_max = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_max", cfg)
        

        if (add_vit >= Number(add_vit_max)) {
             //恢复次数用完
            this._lb_time.innerHTML = HtmlColorTxt("今日体力已回复完毕", '"#0a953e"')
			this.ClearTimer()
		}else{
            this.cur_vit = vit
            if (vit >= max_vit) {
                //体力值满的情况下
                this._lb_time.innerHTML = HtmlColorTxt("当前体力值已满", '"#0a953e"')
                this.ClearTimer()
            } else {
             
                let v = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? 0.8 : 1
                let end_time = last_vit_time + /**(max_vit - vit) **/ time * v
    
                let func_time=()=>{
                    let left_time = end_time - TimeUtil.getServerTime()
                    if(left_time >= 0){
                        let time_str = TimeUtil.timeConvert(left_time, "hh:MM:ss")
                        let str_ = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? `${time_str}（月卡加速中）` : time_str
                        this._lb_time.innerHTML = `${HtmlColorTxt(str_, '"#0a953e"')}后恢复1点体力`  
                    }else{
                        this.ClearTimer()
                        if(this.req_vit!=this.cur_vit){
                            this.req_vit = this.cur_vit
                            //刷新体力值
                            BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
                        }else{
                        }
                    }
                 
                }
    
    
    
                if (!this.time_id) {
                    this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
                        func_time()
                    }, 1, -1)
    
                    func_time()
                }
            }
    
        }


    }
    public ClearTimer() {

        if (this.time_id) {
            GlobalTimerQuest.CancelQuest(this.time_id)
            this.time_id = null
        }
    }
    private SetGoods() {
        let goods_num = GoodsModel.GetInstance().GetBagGoodsNum(this.tried_goods_id)
        this.btn_text.text = goods_num > 0 ? "使用" : "获取"
        let source = goods_num > 0 ? "ui_button_rect9" : "ui_button_rect8"
        let color = goods_num > 0 ? "#186e74" : "#ea6e58"
        this.btn_text.color = color
        ResManager.GetInstance().SetImageSprite(this, this.btn_img, "common_asset", source)
        this.have_goods = goods_num > 0
        if (!this.reward_item) {
            this.reward_item = new EquipmentItem(this.item_gp)
           
            this.reward_item.SetItemSize(85, 85)
            this.reward_item.ExcuteCallback(() => {
                this.reward_item.SetData(this.tried_goods_id, goods_num, 0)
            })
            this.reward_item.Load()
        }
        
        if(this.reward_item.is_loaded){
            this.reward_item.SetData(this.tried_goods_id, goods_num, 0)
        }

    }
    private SetVip() {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false)
        let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
        let vit = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "init_vit", cfg1)
        if (!cfg) return
        let mine_vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
        let now_add = cfg[`${460}@${4601201}@${99}@${mine_vip}`] ? cfg[`${460}@${4601201}@${99}@${mine_vip}`].num : 0
        let max_level = 0
        let max_add = 0
        let next_add = 0
        let next_level = 0
        for (let i = 0; i < 16; i++) {
            //if (i != mine_vip) {
            let add = cfg[`${460}@${4601201}@${99}@${i}`] ? cfg[`${460}@${4601201}@${99}@${i}`].num : 0
            if (add > now_add && next_add == 0) {
                next_add = add
                next_level = i
            }
            if (add > max_add) {
                max_add = add
                max_level = i
            }

            //}
            let is_max = mine_vip >= max_level
            this.right_gp.visible = this.arrow.visible = !is_max
            this.left_gp.centerX = !is_max ? -145 : 0
            this.tip.text = is_max ? "当前VIP等级已达到最高体力上限" : "提升VIP等级可以提升体力上限"
            ResManager.GetInstance().SetImageSprite(this, this.right_vip, "common4", `com_vip${next_level}`, true)
            ResManager.GetInstance().SetImageSprite(this, this.left_vip, "common4", `com_vip${mine_vip}`, true)
            this.left_tired.text = String(Number(now_add) + Number(vit))
            this.right_tired.text = String(Number(next_add) + Number(vit))
        }

    }

    public Open(...new_args) {

        if (new_args && new_args.length > 0) {
            this.boss_vo = new_args[0]
        }
        super.Open()
    }



    close: Laya.Image
    bg1: Laya.Image
    _box_info: Laya.Box
    tired: Laya.HTMLDivElement
    tired_tip: Laya.HTMLDivElement
    _lb_time: Laya.HTMLDivElement
    item_gp: Laya.Box
    use: Laya.Box
    btn_img: Laya.Image
    btn_text: Laya.Label
    left_gp: Laya.Box
    left_vip: Laya.Image
    left_tired: Laya.Label
    right_gp: Laya.Box
    right_vip: Laya.Image
    right_tired: Laya.Label
    arrow: Laya.Image
    tip: Laya.Label
    go: Laya.Label
    public GetComponents() {
        [
            this.close,
            this.bg1,
            this._box_info,
            this.tired,
            this.tired_tip,
            this._lb_time,
            this.item_gp,
            this.use,
            this.btn_img,
            this.btn_text,
            this.left_gp,
            this.left_vip,
            this.left_tired,
            this.right_gp,
            this.right_vip,
            this.right_tired,
            this.arrow,
            this.tip,
            this.go,
        ]
            = this.GetChildrenByNames([

                "close",
                "bg1",
                "_box_info",
                "tired",
                "tired_tip",
                "_lb_time",
                "item_gp",
                "use",
                "btn_img",
                "btn_text",
                "left_gp",
                "left_vip",
                "left_tired",
                "right_gp",
                "right_vip",
                "right_tired",
                "arrow",
                "tip",
                "go",
            ])
    }
}
window["BossFieldTiredNewView"] = BossFieldTiredNewView