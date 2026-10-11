
import { Alert, Alert_Type } from '../alert/Alert';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { GuildFightEvent, GuildFightModel } from '../commonModel/GuildFightModel';
import { RoleManager } from '../commonModel/RoleManager';
import { SeaHegemonyModel } from '../commonModel/SeaHegemonyModel';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { SYTweenFunc } from '../util/SYTweenFunc';
import { SYTweenLite } from '../util/SYTweenLite';
import { Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
import { SeaAssertLabelView } from './SeaAssertLabelView';
export class SeaAssertView extends BaseItem1 {
    InitEvent
    LoadEffects
    LoadSuccess
    ReOpen_callback
    cache_sort_order
    initLabel
    initView
    showAlert
    updateRed
    updateView

    private confSeacraftCamp: any;
    private tween_id1: number;
    private label_list: any[] = [];

    public constructor(parent?) {
        super(parent)

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertView"
        let _model: SeaHegemonyModel = SeaHegemonyModel.GetInstance()

        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        let req = false
        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        }

        this.preload_server_config = {
            config_seacraft_camp: false,
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._introduc, () => {
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_INSTRUCTION_VIEW, InstructionType.SeaAssert)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._gp_reward, () => {
                    _model.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaAssertRewardView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._diplomacy, () => {
                    Message.show("敬请期待")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._gp_click1, () => {
                    if (!_model.assert_in_alert && _model.seaHegemonyData.camp != 1) {
                        this.showAlert(1)
                    } else {
                        _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18702, "c", 1)
                    }
                },
                this, true
            )
            Util.AddClickEvent(
                this._gp_click2, () => {
                    if (!_model.assert_in_alert && _model.seaHegemonyData.camp != 2) {
                        this.showAlert(2)
                    } else {
                        _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18702, "c", 2)
                    }
                },
                this, true
            )
            Util.AddClickEvent(
                this._gp_click3, () => {
                    if (!_model.assert_in_alert && _model.seaHegemonyData.camp != 3) {
                        this.showAlert(3)
                    } else {
                        _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18702, "c", 3)
                    }
                },
                this, true
            )
            Util.AddClickEvent(
                this._gp_click4, () => {
                    if (!_model.assert_in_alert && _model.seaHegemonyData.camp != 4) {
                        this.showAlert(4)
                    } else {
                        _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18702, "c", 4)
                    }
                },
                this, true
            )
            Util.AddClickEvent(
                this.rankBox, () => {
                    _model.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaAssertRankView");
                },
                this, true
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_VIEW_DATA, () => {
                    this.initLabel()
                }
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_GUILD_DATA, () => {
                    this.initLabel()
                }
            )
            this.BindEvent(
                GuildFightModel.GetInstance(),
                GuildFightEvent.UPDATE_REQUEST_FIGURE, (scmd?) => {
                    if (scmd.model_id != 186) {
                        return
                    }
                    this.initView(scmd.figure.name)
                }
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.REFRESH_RED, (id?) => {
                    if (id == 4) {
                        this.updateRed()
                    }
                }
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.KING_INFO, () => {
                    this.updateView()
                }
            )
        }

        this.ReOpen_callback = () => {
            this.LoadEffects()
        }

        this.LoadEffects = () => {
            // this.AddUIEffect("ui_seawar_door", this._gp_ef1, { x: 85, y: -83 }, 1, false)
            // this.AddUIEffect("ui_seawar_door", this._gp_ef2, { x: 85, y: -83 }, 1, false)
            // this.AddUIEffect("ui_seawar_door", this._gp_ef3, { x: 85, y: -83 }, 1, false)
            // this.AddUIEffect("ui_seawar_door", this._gp_ef4, { x: 85, y: -83 }, 1, false)
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetImageSpriteTrans(this, this._img_top, GameResPath.GetIcon("seaAssert", "uisdbz_027"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img1, GameResPath.GetIconOtherPath("seaAssert", "uisdbz_014"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img2, GameResPath.GetIconOtherPath("seaAssert", "uisdbz_015"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img3, GameResPath.GetIconOtherPath("seaAssert", "uisdbz_018"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img4, GameResPath.GetIconOtherPath("seaAssert", "uisdbz_016"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img5, GameResPath.GetIconOtherPath("seaAssert", "uisdbz_017"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img6, GameResPath.GetIconOtherPath("seaAssert", "uisdbz_019"))

            ResManager.GetInstance().SetImageSpriteTrans(this, this.arrowImg1, GameResPath.GetIcon("longlanguage", "img_arrow_yellow"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this.arrowImg2, GameResPath.GetIcon("longlanguage", "img_arrow_yellow"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this.arrowImg3, GameResPath.GetIcon("longlanguage", "img_arrow_yellow"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this.arrowImg4, GameResPath.GetIcon("longlanguage", "img_arrow_yellow"))

            this.SetEffecs(this.tipsBox1);
            this.SetEffecs(this.tipsBox2);
            this.SetEffecs(this.tipsBox3);
            this.SetEffecs(this.tipsBox4);

            this.confSeacraftCamp = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_camp", false)

            // this.cache_sort_order = this.AddCurrLayerSortingOrder(this.layer_value)
            this.LoadEffects()

            _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18701);
            _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18715);
            this.updateView();
            if (_model.assert_login_red) {
                _model.assert_login_red = false
                _model.Fire(SeaHegemonyModel.REFRESH_RED, 4)
                local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 6210)
                local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1861)
            }
            this.updateRed()
        }


        this.updateView = () => {
            if ((_model.seaKingData && _model.seaKingData.server_id) && _model.seaKingData.guild_id) {
                GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, 13014, "hlh", _model.seaKingData.server_id, _model.seaKingData.guild_id, 186)
            } else {
                if (!req) {
                    req = true
                    _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18615)
                } else {
                    this.initView(null)
                }
            }
        }

        this.initView = (_name?) => {
            let sea_str = "虚位以待";
            let name_str = "虚位以待";
            let guild_str = "虚位以待";
            // 判断自己是否是海域霸主.
            let roleName: string = RoleManager.GetInstance().GetMainRoleVo().name;
            let bool: boolean = _model.seaKingData?.camp > 0 && _model.seaHegemonyData?.camp == _model.seaKingData.camp && roleName == _model.seaHegemonyData?.king_name;
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("seaAssert", bool ? 'uisdbz_025_1' : 'uisdbz_025'))
            if (_name != null) {
                let name_cfg = this.confSeacraftCamp;
                // [ts2lua]name_cfg下标访问可能不正确
                let cfg = name_cfg[_model.seaKingData.camp]
                sea_str = cfg.name;
                name_str = _name;
                guild_str = _model.seaKingData.guild_name;
            }                       
            this._lb_sea.text = `${sea_str}`;
            this._lb_name.text = `${name_str}`;
            this._lb_guild.text = `${guild_str}`;
        }

        this.initLabel = () => {
            if (_model.assertViewData && _model.assertGuildData) {
                let i = 0
                do {
                    let label = this.label_list[i]
                    if (!label) {
                        // [ts2lua]this下标访问可能不正确
                        let gp = this["_gp" + (i + 1)]
                        label = new SeaAssertLabelView(gp)
                        label.Load()
                        table.insert(this.label_list, label)
                    }
                    label.setData(i + 1)
                    i = i + 1
                } while ((i < 4))
            }
        }

        this.updateRed = () => {
            this._reward_red.visible = _model.assert_red
        }

        this.showAlert = (sea_id?) => {
            let name_cfg = this.confSeacraftCamp;
            // [ts2lua]name_cfg下标访问可能不正确
            let cfg = name_cfg[sea_id]
            Alert.Show(
                Util.StrToHTML("是否进入" + cfg.name + "？"),
                Alert_Type.AlertTypeCheckBox, () => {
                    _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18702, "c", sea_id)
                },
                null,
                "确定",
                "取消",
                null,
                false, (bool?) => {
                    _model.assert_in_alert = bool
                },
                "本次登录不再提示"
            )
        }
    }

    private SetEffecs(box: Laya.Box) {
        if (!this.tween_id1) {
            this.tween_id1 = SYTweenLite.to(
                this,
                box,
                SYTweenLite.UiAnimationType.POSY,
                box.y - 30,
                2.2,
                null,
                SYTweenFunc.PINGPONG,
                true
            );
        } else {
            SYTweenLite.to(
                this,
                box,
                SYTweenLite.UiAnimationType.POSY,
                box.y - 30,
                2.2,
                null,
                SYTweenFunc.PINGPONG,
                true
            );
        }
    }

    public DeleteMe() {
        for (let key in this.label_list) {
            // [ts2lua]label_list下标访问可能不正确
            let label = this.label_list[key]
            label.DeleteMe();
        }
        this.label_list = [];

        if (this.tween_id1) {
            this.tween_id1 = null;
        }

        super.DeleteMe();
    }


    _img3: Laya.Image
    _img6: Laya.Image
    _introduc: Laya.Image
    _gp_reward: Laya.Box
    _reward: Laya.Image
    _reward_red: Laya.Image
    _diplomacy: Laya.Image
    _img_top: Laya.Image
    _lb_time: Laya.Label
    _Group1: Laya.Box
    _Image2: Laya.Image
    _Image3: Laya.Image
    _lb_sea: Laya.Label
    _lb_guild: Laya.Label
    _Label1: Laya.Label
    _lb_name: Laya.Label
    _gp_click1: Laya.Box
    _img1: Laya.Image
    _gp1: Laya.Box
    _gp_ef1: Laya.Box
    tipsBox1: Laya.Box
    arrowImg1: Laya.Image
    _gp_click2: Laya.Box
    _img2: Laya.Image
    _gp2: Laya.Box
    _gp_ef2: Laya.Box
    tipsBox2: Laya.Box
    arrowImg2: Laya.Image
    _gp_click3: Laya.Box
    _img4: Laya.Image
    _gp3: Laya.Box
    _gp_ef3: Laya.Box
    tipsBox3: Laya.Box
    arrowImg3: Laya.Image
    _gp_click4: Laya.Box
    _img5: Laya.Image
    _gp4: Laya.Box
    _gp_ef4: Laya.Box
    tipsBox4: Laya.Box
    arrowImg4: Laya.Image
    rankBox: Laya.Box
    public GetComponents() {
        [
            this._img3,
            this._img6,
            this._introduc,
            this._gp_reward,
            this._reward,
            this._reward_red,
            this._diplomacy,
            this._img_top,
            this._lb_time,
            this._Group1,
            this._Image2,
            this._Image3,
            this._lb_sea,
            this._lb_guild,
            this._Label1,
            this._lb_name,
            this._gp_click1,
            this._img1,
            this._gp1,
            this._gp_ef1,
            this.tipsBox1,
            this.arrowImg1,
            this._gp_click2,
            this._img2,
            this._gp2,
            this._gp_ef2,
            this.tipsBox2,
            this.arrowImg2,
            this._gp_click3,
            this._img4,
            this._gp3,
            this._gp_ef3,
            this.tipsBox3,
            this.arrowImg3,
            this._gp_click4,
            this._img5,
            this._gp4,
            this._gp_ef4,
            this.tipsBox4,
            this.arrowImg4,
            this.rankBox,
        ]
            = this.GetChildrenByNames([

                "_img3",
                "_img6",
                "_introduc",
                "_gp_reward",
                "_reward",
                "_reward_red",
                "_diplomacy",
                "_img_top",
                "_lb_time",
                "_Group1",
                "_Image2",
                "_Image3",
                "_lb_sea",
                "_lb_guild",
                "_Label1",
                "_lb_name",
                "_gp_click1",
                "_img1",
                "_gp1",
                "_gp_ef1",
                "tipsBox1",
                "arrowImg1",
                "_gp_click2",
                "_img2",
                "_gp2",
                "_gp_ef2",
                "tipsBox2",
                "arrowImg2",
                "_gp_click3",
                "_img4",
                "_gp3",
                "_gp_ef3",
                "tipsBox3",
                "arrowImg3",
                "_gp_click4",
                "_img5",
                "_gp4",
                "_gp_ef4",
                "tipsBox4",
                "arrowImg4",
                "rankBox",
            ])
    }
}
window["SeaAssertView"] = SeaAssertView