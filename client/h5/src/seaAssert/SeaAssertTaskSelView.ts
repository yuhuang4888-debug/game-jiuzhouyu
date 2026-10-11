import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Scene } from "../scene/Scene"
import { Message } from "../sysInfo/SysInfoController"
import { HtmlColorTxt, SetLocalPositionX, Util } from "../util/Util"
import { Config } from "../common/Config";
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { table } from "../common/table"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { SeaAssertTaskSelItem } from "./SeaAssertTaskSelItem"

export class SeaAssertTaskSelView extends BaseView1 {
    InitEvent
    LoadSuccess
    close_callback
    destroy_imm
    initInfo
    initItem

    private confBrick: any;
    private confExp: any;
    private confBuilding: any;
    private confKv: any;

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertTaskSelView"
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.back_login_toClose = true;
        let _model: SeaHegemonyModel = SeaHegemonyModel.GetInstance()
        let item_ac: LoopScrowViewMgr = null

        let goodsModel = GoodsModel.GetInstance()
        let canUp = true
        let nedd_goods_num = 0
        let needId = 0
        let scene = Scene.GetInstance()
        this.preload_server_config = {
            config_sea_craft_daily_brick: false,
            config_sea_craft_daily_exp: false,
            config_sea_craft_daily_building: false,
            config_sea_craft_daily_kv: false
        }

        this.load_callback = () => {

            this.InitEvent()
            this.LoadSuccess()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._close, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._btn_up, () => {
                    if (scene.main_role && scene.main_role.vo.brick_id > 0) {
                        Message.show("请先卸下砖块再提升品质")
                        return
                    }
                    if (!canUp) {
                        Message.show("当前砖块已达到最高级")
                        return
                    }
                    let fun = () => {
                        let viewData = _model.getAssertViewData(_model.assertSceneData.sea_id)
                        let cur_lv = viewData.brick_color
                        _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18707, "c", cur_lv + 1)
                    }

                    if (nedd_goods_num < 0) {
                        // [ts2lua]Config.PRELOAD_SETVER_CONFIG.config_goods_price下标访问可能不正确
                        let goodsPriceCfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price
                        let priceCfg = goodsPriceCfg[Number(needId)];
                        let str: string = Util.StrToHTML("当前圣殿令道具不足，是否额外花费<font color='#34a064'>" + nedd_goods_num * priceCfg.price * (-1) + "</font>勾玉补足<font color='#34a064'>(优先消耗绑玉)</font>")
                        if (_model.assert_brick_alert1) {
                            fun();
                        } else {
                            Alert.Show(
                                str,
                                Alert_Type.AlertTypeCheckBox, () => {
                                    fun();
                                },
                                null,
                                "确定",
                                "取消",
                                null,
                                false, (bool?) => {
                                    _model.assert_brick_alert1 = bool
                                },
                                "本次登录不再提示"
                            )
                        }
                        return
                    } else {
                        fun();
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._btn_go, () => {
                    if (scene.main_role && Scene.GetInstance().main_role.vo.god_id > 0) {
                        Message.show("变身中，不能采集海域的砖块")
                        return
                    }
                    let fun = () => {
                        _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18705, "c", _model.assertSceneData.sea_id)
                    }

                    let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
                    // [ts2lua]kv_cfg下标访问可能不正确
                    let max = kv_cfg["defend_count"].value
                    let data = _model.assertSceneData
                    if (max - data.carry_count > 0 || _model.assert_brick_alert) {
                        fun();
                    } else {
                        let str: string = "今天搬砖次数已用完，后续上交不再获得额外奖励，是否继续？"
                        Alert.Show(
                            str,
                            Alert_Type.AlertTypeCheckBox, () => {
                                fun();
                            },
                            null,
                            "确定",
                            "取消",
                            null,
                            false, (bool?) => {
                                _model.assert_brick_alert = bool
                            },
                            "本次登录不再提示"
                        )


                    }
                },
                this,
                true
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_BRICK_UP, () => {
                    this.initItem()
                }
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_BRICK_ING, () => {
                    this.Close()
                }
            )
            this.BindEvent(
                goodsModel,
                GoodsModel.CHANGE_BAG_LIST, () => {
                    if (!this.use_delete_method) {
                        this.initInfo()
                    }
                }
            )
        }

        this.LoadSuccess = () => {
            this.confKv = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
            this.confBuilding = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_building", false);
            this.confExp = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_exp", false);
            this.confBrick = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_brick", false);
            this.initItem()
        }

        this.open_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIconOtherPath("seaAssert", "ui_bright_17"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2Img, GameResPath.GetIconOtherPath("seaAssert", "ui_bright_18"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg3Img, GameResPath.GetIconOtherPath("seaAssert", "ui_bright_19"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIconOtherPath("seaAssert", "ui_bright_23"))
        }

        this.close_callback = () => {
            if (item_ac) {
                item_ac.DeleteMe()
                item_ac = null
            }
        }

        this.initItem = () => {
            let viewData = _model.getAssertViewData(_model.assertSceneData.sea_id)
            let cur_lv = viewData.brick_color
            let task_config = this.confBrick;
            let exp_config = this.confExp;
            let brick_lv_config = this.confBuilding;
            let data = []
            let baseExp = _model.assertTaskExp(exp_config)
            let lv_cfg = _model.GetAssertBrickLv(brick_lv_config, _model.assertSceneData.brick_num)
            for (let key in task_config) {
                // [ts2lua]task_config下标访问可能不正确
                let task = task_config[key]
                // [ts2lua]task下标访问可能不正确
                task["baseExp"] = baseExp
                // [ts2lua]task下标访问可能不正确
                task["brick_lv"] = lv_cfg.lv
                table.insert(data, task)
            }
            table.sort(data, (a?, b?) => {
                if (a.id != b.id) {
                    return a.id > b.id
                }
                return false
            })
            if (!item_ac) {
                item_ac = new LoopScrowViewMgr()
                item_ac.SetData(this._Scroller1, SeaAssertTaskSelItem, data, LoopScrCon.Vertical)
                item_ac.SetSelectIndex(0)
                //this._list.dataProvider = item_ac
                //this._list.itemRenderer = SeaAssertTaskSelItem
                //this._list.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.itemTouch, this)
                //this._list.selectedIndex = 0
            } else {
                item_ac.replaceAll(data)
            }
            this.initInfo()
        }

        this.initInfo = () => {
            let viewData = _model.getAssertViewData(_model.assertSceneData.sea_id)
            let cur_lv = viewData.brick_color
            let task_config = this.confBrick;
            // [ts2lua]task_config下标访问可能不正确
            let cfg = task_config[cur_lv];
            this._lb_desc.style.fontSize = 20;
            this._lb_desc.style.color = '#FFFFFF';
            this._lb_desc.style.width = 450;
            if (cfg) {
                // [ts2lua]task_config下标访问可能不正确
                let nextCfg = task_config[cur_lv + 1]
                let desc = `当前是普通钻块,消耗圣殿令${HtmlColorTxt('1/4', "'#25FF4E'")}即可提升至${HtmlColorTxt('铜砖', "'#FED062'")}`;
                if (nextCfg) {
                    let cost = JSON.parse(cfg.cost)[0]
                    needId = cost[1]
                    let needCount = cost[2]
                    let count = goodsModel.GetTypeGoodsNum(needId)
                    nedd_goods_num = count - needCount;
                    desc = "当前是" + cfg.name + ",消耗圣殿令" + HtmlColorTxt(count + "/" + needCount, count >= needCount ? "'#25FF4E'" : "'#FED062'") + "即可提升至" + HtmlColorTxt(nextCfg.name, "'#FED062'")
                    canUp = true;
                } else {
                    desc = "当前砖块已达到最高级"
                    canUp = false;
                }
                SetLocalPositionX(this._lb_desc, canUp ? 154 : 264);
                this._lb_desc.innerHTML = Util.StrToHTML(desc)
            }
        }
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    _bg: Laya.Image
    _close: Laya.Image
    bg2Img: Laya.Image
    _Image1: Laya.Image
    bg3Img: Laya.Image
    _Image2: Laya.Image
    _lb_desc: Laya.HTMLDivElement
    _btn_up: Laya.Box
    _Image111: Laya.Image
    labelDisplay1: Laya.Label
    _btn_go: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _Scroller1: Laya.List
    public GetComponents() {
        [
            this._bg,
            this._close,
            this.bg2Img,
            this._Image1,
            this.bg3Img,
            this._Image2,
            this._lb_desc,
            this._btn_up,
            this._Image111,
            this.labelDisplay1,
            this._btn_go,
            this._Image11,
            this.labelDisplay,
            this._Scroller1,
        ]
            = this.GetChildrenByNames([

                "_bg",
                "_close",
                "bg2Img",
                "_Image1",
                "bg3Img",
                "_Image2",
                "_lb_desc",
                "_btn_up",
                "_Image111",
                "labelDisplay1",
                "_btn_go",
                "_Image11",
                "labelDisplay",
                "_Scroller1",
            ])
    }
}
window["SeaAssertTaskSelView"] = SeaAssertTaskSelView