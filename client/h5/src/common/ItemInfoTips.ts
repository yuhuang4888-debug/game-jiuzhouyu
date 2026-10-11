import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { HtmlColorTxt, Trim, Util } from "../util/Util";
import { BaseView1 } from "./BaseView1"
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager";
import { table } from "./table";
import { ErlangParser } from './../util/ErlangParser';
import { Config } from "./Config"
import { WordManager } from "./WordManager";
import { SceneManager } from "../scene/SceneManager";
import { TreasureMapModel } from "../commonModel/TreasureMapModel";
import { Message } from "../sysInfo/SysInfoController";
import { BagModel } from "../commonModel/BagModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Alert, Alert_Type } from "../alert/Alert";
import { DsgtModel } from "../commonModel/DsgtModel";
import { OpenFun } from "./OpenFun";
import { MaskModel } from "../commonModel/MaskModel";
import { PartnerModel } from "../commonModel/PartnerModel";
import { BaseAwardItem } from "./BaseAwardItem";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { Vector3 } from "../util/Vector3";
import { UI_MODEL_TYPE } from "./UIModelClass3D";
import { SYTweenLite } from "../util/SYTweenLite";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { LoopScrCon, LoopScrowViewMgr } from "./LoopScrowViewMgr";
import { ItemInfoItem } from "./ItemInfoItem";
import { TimeUtil } from "../util/TimeUtil";

export class ItemInfoTips extends BaseView1 {
    private _item: BaseAwardItem;
    private conf: any;
    // private confGift: any;
    private confModel: any;
    private confGiftBox: any;
    private goods: any;
    private itemId: any;
    private ids: number[] = [];
    private curIndex: number = 0;
    private isUseBtn: boolean = false;
    private goodsNum: number = 0;
    private tween_id: number = 0;
    private _data: any;
    private loop_mgr: LoopScrowViewMgr;
    private icons: any[] = [];

    public constructor() {
        super()
        this.base_file = "common";
        this.layout_file = "ItemInfoTips";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true;
        this.destroy_imm = true
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        this.load_callback = function () {
            this.InitEvent();
            this.LoadSuccess();
            this.UpdateView()
        }


        this.close_callback = () => {
            this.curIndex = 0;
            this.ids = [];
            this._item = null;
            this.tween_id = 0;

            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
            GlobalEventSystem.Fire(EventName.CLOSE_TIPS_VIEW)
        }


        this.preload_server_config = {
            config_treasure_map_new: false,
            // config_optional_gift: false,
            config_gift_box: false
        }

        this.preload_client_config = {
            ConfigItemInfoModel: false
        }

    }

    public LoadSuccess() {
        // this.confGift = ResManager.GetInstance().GetGameConfigFromCache(this, "config_optional_gift", false);
        this.conf = ResManager.GetInstance().GetGameConfigFromCache(this, "config_treasure_map_new", false);
        this.confModel = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigItemInfoModel");
        this.confGiftBox = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gift_box", false)
        //resource/game/common4/other/ui_tips_04.png
        // ResManager.GetInstance().SetTexture(
        //     this,
        //     this.bgImg,
        //     GameResPath.GetIconOtherPath('common4', 'ui_tips_04')
        // );
        //resource/game/common/other/ui_tips_04.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this.bgImg, GameResPath.GetIconOtherPath("common4", "ui_tips_04"))
    }



    public InitEvent() {
        // 使用
        Util.AddClickEvent(
            this.useBtn,
            () => {
                if (this.isUseBtn) {
                    this.useItem();
                }
                this.Close();
            },
            this,
            true
        );


        // 查看概率
        Util.AddClickEvent(
            this.probabilityImg,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 20301);
            },
            this,
            true
        );

        // 点击查看下一个古宝
        Util.AddClickEvent(this.rImg, () => {
            this.ClickRight();
        }, this, true);

        // 点击查看上一个古宝
        Util.AddClickEvent(this.lImg, () => {
            this.ClickLeft();
        }, this, true);

        // 查看奖池
        Util.AddClickEvent(
            this.jackpotImg,
            () => {
                let rewards = this.conf;
                let list = [];
                if (rewards) {
                    for (const i in rewards) {
                        let vo = rewards[i]
                        if (vo.type == 2) {
                            let _reward = JSON.parse(vo.reward_list)
                            let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(_reward[0][0], _reward[0][1])
                            let v = []
                            v[0] = type
                            v[1] = _reward[0][2]
                            table.insert(list, v)
                        }
                    }
                }

                if (list.length > 0) {
                    CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.OPEN_CUSTOM_VIEW, "CommonActRewardPreview", "customActivity", list, true)
                }
            },
            this,
            true
        );

    }


    public UpdateView() {
        let basic = this.goods;
        let confGiftBox = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, basic.type_id, false, this.confGiftBox);
        let isList: boolean = Boolean(confGiftBox?.show_reward);
        this.rewardsList.visible = isList;

        //resource/game/common4/texture/ui_tips_pz_7.png
        this.quaImg.skin = GameResPath.GetIcon('common4', 'ui_tips_pz_' + basic.color)

        // ResManager.GetInstance().SetImageSpriteTrans(
        //     this,
        //     this.titleImg,
        //     GameResPath.GetIcon('itemInfo', basic.type == 75 ? 'ui_zsjli_02' : 'ui_zsjli_01')
        // );
        this.titleImg.visible = false
        { // 渲染基础属性
            let attr = ErlangParser.GetInstance().Parse(basic.base_attrlist)
            // if (basic.type == 38 && basic.subtype == 6) {
            // 	//勋章碎片属性换行处理
            // 	let r1: RegExp = /<\/font>/g
            // 	let r2 = "</font><br/>"
            // 	intro = intro.replace(r1, r2)
            // }
            let intro = Trim(basic.intro) != "" && Trim(basic.intro) || "";
            if (attr.length > 0) {
                let attCfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
                let sortFunc = (a?, b?) => {

                    let a_value = Number(a[0])
                    let b_value = Number(b[0])

                    let acfg = attCfg[Number(a[0])]
                    let is_a_kind = acfg && acfg.kind && acfg.kind == 2
                    let bcfg = attCfg[Number(b[0])]
                    let is_b_kind = bcfg && bcfg.kind && bcfg.kind == 2
                    if (is_a_kind) {
                        a_value += 1000
                    }

                    if (is_b_kind) {
                        b_value += 1000
                    }
                    return a_value < b_value
                }

                let color = "#0a953e"
                table.sort(attr, sortFunc)

                for (let _tmpi in attr) {
                    var vo = attr[_tmpi]
                    let cfg = attCfg[Number(vo[0])]
                    if (cfg && cfg.kind == 2) {
                        color = "#f551ff"
                        intro = intro + "<br><font color='" + color + "'>" + WordManager.GetProperties(vo[0]) + "+" + "</font>" + "<font color='" + color + "'>" + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>"
                    } else {
                        color = "#0a953e"
                        intro = intro + "<br><font color='#5a1c20'>" + WordManager.GetProperties(vo[0]) + "+" + "</font>" + "<font color='" + color + "'>" + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font>"
                    }
                }
            } else if (basic.type == GoodsModel.GIFT_TYPE) { // 随机礼包
                intro = this.GetGiftBagRewardDesc(basic.type_id, RoleManager.GetInstance().GetMainRoleLevel(), isList)
            } else if (basic.type == 34) { // 自选礼包
                let desStr
                let cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(basic.type_id, RoleManager.GetInstance().GetMainRoleCareer());
                if (!cfg) {
                    cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(basic.type_id, 0);
                }
                if (cfg) {
                    desStr = "打开可选以下奖励一个：";
                    let rewardList = JSON.parse(cfg.list);
                    if (!isList) {
                        for (let i in rewardList) {
                            let v = rewardList[i]
                            let giftgoodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(v[1])
                            desStr = desStr + "<br>" + HtmlColorTxt(Trim(giftgoodsBasic.goods_name) + "*" + v[2], ColorUtil.GetColorLight(giftgoodsBasic.color))
                        }
                    }
                } else {
                    desStr = Trim(basic.intro)
                }
                intro = desStr;
            } else {
                if (basic.type == 14 && (basic.subtype == 1 || basic.subtype == 2)) {
                    this.label1.text = "镶嵌属性";
                }
                intro = Util.StrToHTML(Trim(basic.intro) != "" && Trim(basic.intro) || "")
            }
            this.intro.style.leading = 10;
            this.intro.innerHTML = Util.StrToHTML(intro);
        }

        { // 道具icon
            if (!this._item) {
                this._item = new BaseAwardItem(this.iconBox);
                this._item.Load();
                this._item.SetItemSize(87, 87);
            }
            this._item.SetData(basic.type_id);
            this._item.SetShowTips(false);
        }
        let num: number = this.goodsNum || GoodsModel.GetInstance().GetBagGoodsNum(basic.type_id);
        let style = WordManager.GetGoodsStyle(Number(basic.type));

        let color = Enum_ColorUtil_Dark.YELLOW
        this.type_text.innerHTML = `类型:&nbsp;<font color=${color}>${style}</font>`;
        this.quantity_text.innerHTML = `数量:&nbsp;<font color=${color}>${num}</font>`;
        this.quantity_text.visible = Boolean(num);
        this.level_text.visible = Boolean(basic?.level);
        if (basic?.level) {
            let color = RoleManager.GetInstance().GetMainRoleLevel() < basic.level ?
            Enum_ColorUtil_Dark.RED : Enum_ColorUtil_Dark.YELLOW
            this.level_text.innerHTML = `等级需求:&nbsp;<font color=${color}>${basic.level}</font>`
            // 恢复默认y
            this.type_text.y = 52;
            this.type_text.style.fontSize = 22
            this.quantity_text.y = 85;
            this.quantity_text.style.fontSize = 22
        } else {
            this.type_text.y = 57;
            this.type_text.style.fontSize = 24
            this.quantity_text.y = 104;
            this.quantity_text.style.fontSize = 24
        }

        this.goods_name.text = basic.goods_name; // Util.StrToHTML("<font color=" + color_str + ">" +  + "</font>")

        // 藏宝图类型道具才显示
        this.probabilityImg.visible = basic.type == 75;
        this.jackpotImg.visible = basic.type == 75;


        // 自适应高度
        this.intro.width = this.intro.contextWidth + 15;
        this.intro.height = this.intro.contextHeight + 5;
        if (this.intro.height >= 120) {
            let offset = this.intro.height - 120
            
            this.detail_scroller.height += offset;

            let height = this.bgImg.height
            height += offset
            this.bgImg.height = height
            this.display_obj.height = height;

        }

        this.descLab.text = this.isUseBtn ? '使用' : '确定';

        // 根据类型不同指定不同道具id值
        switch (basic.type) {
            case 75: // 藏宝图
                let keys: string[] = Object.keys(this.conf);
                for (const iterator of keys) {
                    let conf = this.conf[iterator];
                    if (conf.rare == 2) { // 稀有类型
                        let award = JSON.parse(conf.reward_list);
                        this.ids.push(award[0][1]);
                    }
                }
                break;
            case 32: // 随机
            case 33: // 勾玉礼包
                let cond_level = GoodsModel.GetInstance().GetGiftBagCondLevel(basic.type_id, confGiftBox)
                let gift_cfg = GoodsModel.GetInstance().GetGiftBagCfg(basic.type_id, cond_level);
                let bool: boolean = JSON.parse(gift_cfg.rand_gifts).length > 0;
                let reards = bool ? JSON.parse(gift_cfg.rand_gifts) : JSON.parse(gift_cfg.fixed_gifts);
                this.icons = reards;
                for (const iterator of reards) {
                    this.ids.push(bool ? iterator[0][1] || iterator[0][0] : iterator[0] || iterator[1]);
                }
                break;
            case 34: // 自选
                let cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(basic.type_id, 0);
                if (!cur_cfg) {
                    cur_cfg = GoodsModel.GetInstance().getOpGiftVoByTypeIdAndCareer(basic.type_id, RoleManager.GetInstance().GetMainRoleCareer());
                    if (!cur_cfg) {
                        return
                    }
                }
                let reards1 = JSON.parse(cur_cfg.list);
                this.icons = reards1;
                for (const iterator of reards1) {
                    this.ids.push(iterator[1] || iterator[0]);
                }
                break;
            case 84: //龙玉觉醒礼包
                this.ids.push(basic.type_id);
            default:
                break;
        }

        // 去重
        this.ids = Array.from(new Set([...this.ids]));
        this.renderModelOrIcon();

        if (isList) {
            // 渲染奖励
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr();
                this.loop_mgr.SetData(
                    this.rewardsList,
                    ItemInfoItem,
                    this.icons,
                    LoopScrCon.Horizontal
                );
            } else {
                this.loop_mgr.replaceAll(this.icons);
            }

        }


    }

    /**
     * 渲染模型/icon
     */
    private renderModelOrIcon() {
        this.lImg.visible = this.curIndex > 0;
        this.rImg.visible = this.curIndex < this.ids.length - 1;
        let model_cfg = this.confModel[this.ids[this.curIndex]];

        this.modelBox.visible = Boolean(model_cfg);
        this.iconImg.visible = !Boolean(model_cfg);

        // 判断是模型还是icon
        if (model_cfg) {
            ResManager.GetInstance().ClearRoleMode(this.$hashCode);
            let role_vo = RoleManager.GetInstance().mainRoleInfo
            let sex = role_vo.sex
            // this.fight.text = model_cfg.fight + (" + ")
            let model_res = 0
            let action_list = null
            let pos = null
            let scale = null
            let rotate = null
            let weapon_res, weapon_texture_id
            let head_model_id, head_clothe_id
            let fashion_model_id, fashion_texture
            model_res = Number(model_cfg.model_res[sex])
            if (model_cfg.action_list) {
                action_list = model_cfg.action_list[sex]
            }
            if (model_cfg.pos) {
                pos = model_cfg.pos[sex]
            }
            if (model_cfg.scale) {
                scale = typeof (model_cfg.scale) == "number" && model_cfg.scale || model_cfg.scale[sex]
            }
            if (model_cfg.rotate) {
                rotate = model_cfg.rotate
            }
            if (model_cfg.model_type == UI_MODEL_TYPE.ROLE) {
                if (model_cfg.type_id == 3) {
                    head_model_id = model_res
                    head_clothe_id = 0
                    model_res = role_vo.GetRoleClotheId()
                    // let [f_model_id, f_texture] = role_vo.GetRoleClotheTextureId()
                    fashion_model_id = model_res
                    fashion_texture = 0
                } else {
                    [head_model_id, head_clothe_id] = role_vo.GetRoleHeadId()// role_vo.GetRoleHeadId()
                }

                let head_data = role_vo.GetRoleHeadId()
                let data = {
                    career: role_vo.career,
                    sex: role_vo.sex,
                    clothe_res_id: model_res,
                    //weapon_res_id : weapon_res,
                    //weapon_clothe_id : weapon_texture_id,
                    type: UI_MODEL_TYPE.MAINROLE,//SceneBaseType.MainRole,
                    layer_value: this.layer_value,
                    scale: scale || 0.75,
                    position: (pos && new Vector3(pos.x, pos.y, 0) || new Vector3(0, 1, 0)),
                    texture_id: fashion_texture,
                    fashion_model_id: fashion_model_id,
                    head_wear_id: head_model_id,
                    head_clothe_id: head_clothe_id,
                    hair_id: head_data[0],
                    layout_file: this.layout_file,
                    rotate: rotate,
                    custom_sorting_order: null,
                    action_name_list: action_list,
                    enableHDR: true
                }
                ResManager.GetInstance().SetRoleModel(this, this.modelBox, data)
            } else {
                let type = model_cfg.model_type
                let wing_id
                if (model_cfg.model_type == UI_MODEL_TYPE.HORSE) {
                    // type = UI_MODEL_TYPE.HORSE
                } else if (model_cfg.model_type == UI_MODEL_TYPE.WING) {
                    // type = UI_MODEL_TYPE.WING
                } else if (model_cfg.model_type == UI_MODEL_TYPE.SPRITE) {
                    // type = UI_MODEL_TYPE.SPRITE
                } else if (model_cfg.model_type == UI_MODEL_TYPE.WEAPON) {
                    weapon_res = model_cfg.model_res[RoleManager.GetInstance().GetMainRoleVo().career]
                    model_res = weapon_res
                    pos = model_cfg.pos[RoleManager.GetInstance().GetMainRoleVo().career]
                    // type = UI_MODEL_TYPE.WEAPON
                } else if (model_cfg.model_type == UI_MODEL_TYPE.ARTIFACT) {
                    // type = UI_MODEL_TYPE.ARTIFACT
                } else if (model_cfg.model_type == UI_MODEL_TYPE.GOD) {
                    // type = UI_MODEL_TYPE.GOD
                    weapon_res = model_res
                    // wing_id = model_res
                }
                let data = {
                    type: type,
                    layer_value: this.layer_value,
                    scale: scale || 0.75,
                    position: pos && new Vector3(pos.x, pos.y, 0) || new Vector3(0, 1, 0),
                    clothe_res_id: model_res,
                    weapon_res_id: weapon_res,
                    wing_id: wing_id,
                    // layout_file: this.layout_file,
                    rotate: rotate,
                    custom_sorting_order: null,
                    action_name_list: Util.DeepCopy(action_list)
                }
                ResManager.GetInstance().SetRoleModel(this, this.modelBox, data)
            }
        } else {
            let typeId: number = this.ids[this.curIndex];
            let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(typeId);
            if (!goods_basic) {
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(typeId, 0);
                goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id);
            }

            ResManager.GetInstance().SetOutsideImageSprite(
                this,
                this.iconImg,
                GameResPath.GetFilePath('goodsIcon', goods_basic.goods_icon)
            );
            if (!this.tween_id) {
                this.tween_id = SYTweenLite.to(
                    this,
                    this.iconImg,
                    SYTweenLite.UiAnimationType.POSY,
                    this.iconImg.y - 30,
                    2.2,
                    null,
                    SYTweenFunc.PINGPONG,
                    true
                );
            }
        }

    }


    /**
     * 渲染道具时间描述
     */
    private renderItemTime() {
        let basic = this.goods;
        let _goods_vo = this._data;
        let _overdue_time = 0; // 没找到传入参数 先默认给0
        if (!basic) {
            return
        }
        let show = false
        if ((_goods_vo && (_goods_vo.expire_time && _goods_vo.expire_time > 0) || _overdue_time > 0) || (basic.expire_time && basic.expire_time != 0)) {
            show = true
            let time_desc = ""
            if (_goods_vo && _goods_vo.expire_time) {
                if (TimeUtil.getServerTime() > _goods_vo.expire_time) {
                    time_desc = "已过期"
                } else {
                    time_desc = "<font color='#639c12'>过期时间：" + TimeUtil.timeConversion(_goods_vo.expire_time, "yyyy/mm/dd hh.MM:ss") + "</font>"
                }
            } else if (_overdue_time != 0) {
                time_desc = "限时：" + TimeUtil.timeConversion(_overdue_time, "yyyy/mm/dd hh.MM:ss")
            } else if (basic.expire_time != 0) {
                if (String(basic.expire_time).indexOf("-") >= 0) {
                    time_desc = "限时：<font color='#639c12'>" + basic.expire_time + "</font>"
                } else {
                    let time = basic.expire_time
                    if (basic.expire_type == 4) {
                        time_desc = "限时：开服" + time + "天内"
                    } else {
                        if (time > 1200000000) {
                            time_desc = "过期时间：" + TimeUtil.timeConversion(time, "yyyy/mm/dd hh.MM:ss")
                        } else {
                            time_desc = "限时：" + TimeUtil.convertTimeColor(time, "yyyy/mm/dd hh.MM:ss")
                        }
                    }
                }
            }
            this.descHtml.innerHTML = Util.StrToHTML(time_desc);
        }
        this.descHtml.visible = show;

    }



    /**
     * 使用道具
     * @returns 
     */
    private useItem() {
        let goods_model = GoodsModel.GetInstance();
        let bag_model = BagModel.GetInstance();
        let role_mgr = RoleManager.GetInstance();
        let _goods_vo = this._data;
        if (_goods_vo == null) {
            return
        }

        this.Close()
        if (_goods_vo.type == 34) {
            if (_goods_vo.level > role_mgr.GetMainRoleVo().level) {
                Message.show("等级不足");
                return
            }
            bag_model.Fire(BagModel.OPEN_VIEW, "SelectGiftView", _goods_vo)
            return
        }
        // if (((_goods_vo.type == 40 && _goods_vo.subtype == 6) && MarriageModel.GetInstance().GetRingInfo()) && MarriageModel.GetInstance().GetRingInfo().star == 0 ) {
        // 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView", 2)
        // 	return
        // }
        // if ((_goods_vo.type == 37 && _goods_vo.subtype == 2) && bag_model.show_exp_tips_view) {
        // 	let buff_list = goods_model.goods_buff_list
        // 	if (buff_list.length > 0) {
        // 		for (let _tmpi in buff_list) {
        // 			let vo = buff_list[_tmpi]
        // 			let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.goods_id)
        // 			if (((goodsbasic && goodsbasic.type == 37) && goodsbasic.subtype == 2) && goodsbasic.type_id != _goods_vo.type_id) {
        // 				Alert.Show(Util.StrToHTML("使用后会替换当前" + local_GoodsModel.GetGoodsNameWithColorDark(goodsbasic.type_id) + "效果，是否继续？"), Alert_Type.AlertTypeCheckBox, () => {
        // 					if (_goods_vo.goods_num <= 1) {
        // 						goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
        // 					} else {
        // 						bag_model.Fire(local_BagModel.OPEN_VIEW, "BatchUseView", _goods_vo)
        // 					}
        // 				}
        // 					, null, null, null, null, null, (bool?) => {
        // 						bag_model.show_exp_tips_view = !bool
        // 					}
        // 				)
        // 				return
        // 			}
        // 		}
        // 	}
        // }
        if (_goods_vo.type == 37 && _goods_vo.subtype == 2) {
            let buff_list = goods_model.goods_buff_list
            if (buff_list.length > 0) {
                for (let _tmpi in buff_list) {
                    let vo = buff_list[_tmpi]
                    let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.goods_id)
                    if ((goodsbasic && goodsbasic.type == 37) && goodsbasic.subtype == 2) {
                        let state = goods_model.HaveHightExpBuff(goodsbasic.type_id, _goods_vo.type_id)
                        if (state == 2) {
                            Alert.Show("当前已存在更高级的经验符,低级经验符将会在高级经验符持续时间过期再生效。<br>是否继续使用？", Alert_Type.Two, () => {
                                if (_goods_vo.goods_num <= 1) {
                                    goods_model.Fire(GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
                                } else {
                                    bag_model.Fire(BagModel.OPEN_VIEW, "BatchUseView", _goods_vo)
                                }
                            })
                            return
                        } else if (state == 1) {
                            goods_model.Fire(GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
                            Alert.Show("已使用更高效经验符。<br>低级经验符将会高级经验符持续时间过期再生效", Alert_Type.One)
                            return
                        }
                    }
                }
            }
        }
        if (_goods_vo.type == 38 && _goods_vo.subtype == 6) {
            DsgtModel.GetInstance().cur_select_dsgt = _goods_vo.type_id
            OpenFun.OpenFunHandler(35)
            return
        }
        // if (_goods_vo.type == 38 && _goods_vo.subtype == 7) {
        // 	let ok_callback = () => {
        // 		goods_model.Fire(local_GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
        // 	}

        // 	let time = DailyModel.GetInstance().outline_info || out_line_model.GetOnhookTime()
        // 	// [ts2lua]out_line_model.add_time下标访问可能不正确
        // 	let add_time = out_line_model.add_time[_goods_vo.type_id]
        // 	if (time + add_time > out_line_model.max_outline_time) {
        // 		let time = local_Math.Floor(out_line_model.max_outline_time / 3600)
        // 		Alert.Show("使用后离线挂机时间将会溢出(最多" + time + "个小时),是否继续使用", Alert_Type.Two, ok_callback)
        // 	} else {
        // 		ok_callback()
        // 	}
        // 	return
        // }
        if (_goods_vo.type == 38 && _goods_vo.subtype == 10) {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageFlowerView")
            return
        }
        if (_goods_vo.type == 75) {
            if (SceneManager.GetInstance().IsFieldScene()) {
                TreasureMapModel.GetInstance().Fire(TreasureMapModel.TM_USE_GOODS, _goods_vo)
            } else {
                Message.show("当前场景不能使用")
            }
            return
        }
        //蒙面人道具
        if (_goods_vo.type == 38 && _goods_vo.subtype == 36) {
            let einfo = MaskModel.GetInstance().GetMaskInfo()
            if (!einfo || einfo.end_time <= 0) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MaskUseView", _goods_vo)
            } else {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MaskAddTimeView", _goods_vo)
            }
            return
        }
        if (_goods_vo.type == 38 && _goods_vo.subtype == 39) {
            if (_goods_vo.level > role_mgr.GetMainRoleVo().level) {
                Message.show("等级不足");
                return
            }
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TransferJobCardView")
            return
        }
        if (_goods_vo.type_id == 37090001) {
            let ok_callback = () => {
                goods_model.Fire(GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
            }
            let level = RoleManager.GetInstance().GetMainRoleLevel()
            //let lv = level > 370 && "神创" + (level - 370) || level
            if (level < 219) {
                Alert.Show("是否使用人物直升丹？[推荐使用等级259级]", Alert_Type.Two, ok_callback)
            } else {
                ok_callback()
            }
            return
        }
        //宝石直升丹
        if (_goods_vo.type == 14 && _goods_vo.subtype == 12) {
            OpenFun.OpenFunHandler(11)
            return
        }
        //伙伴魂珠
        if (_goods_vo.type == 22 && _goods_vo.subtype == 1) {
            let id = PartnerModel.GetInstance().GetIDByRound(_goods_vo.type_id)
            OpenFun.OpenFunHandler(16, id)
            return
        }
        //装扮
        if (_goods_vo.type == 59) {
            OpenFun.OpenFunHandler(203, _goods_vo.subtype, _goods_vo.type_id)
            return
        }

        //古宝
        if (_goods_vo.type == 83 && _goods_vo.subtype == 1) {
            OpenFun.OpenFunHandler(240)
            return
        }


        if (_goods_vo.goods_num <= 1) {
            goods_model.Fire(GoodsModel.USE_BAG_GOODS, _goods_vo.goods_id, 1)
        } else {
            bag_model.Fire(BagModel.OPEN_VIEW, "BatchUseView", _goods_vo)
        }
    }

    private ClickRight() {
        let index: number = this.curIndex + 1;
        if (index <= this.ids.length - 1) {
            this.curIndex = index;
            this.renderModelOrIcon();
        }
    }

    private ClickLeft() {
        let index: number = this.curIndex - 1;
        if (index >= 0) {
            this.curIndex = index;
            this.renderModelOrIcon();
        }
    }

    private GetGiftBagRewardDesc(type_id: number, gift_level: number, isList: boolean) {
        let msg = ""
        let confGiftBox = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, type_id, false, this.confGiftBox);
        let cond_level = GoodsModel.GetInstance().GetGiftBagCondLevel(type_id, confGiftBox)
        let gift_cfg = GoodsModel.GetInstance().GetGiftBagCfg(type_id, cond_level)
        if (gift_cfg) {
            let fixed_gifts = JSON.parse(gift_cfg.fixed_gifts)
            let rand_gifts = JSON.parse(gift_cfg.rand_gifts)
            msg = this.FormatGiftRewardStr(fixed_gifts, true, 0, isList)
            msg = msg + this.FormatGiftRewardStr(rand_gifts, false, gift_cfg.rand, isList)
        }
        return msg

    }

    private FormatGiftRewardStr(list?, is_fix?, times?, isList: boolean = false) {
        let str = "";
        let goods_model = GoodsModel.GetInstance()
        if (list && list.length > 0) {
            let basic_goods = null
            // let vo_type_id = null
            // let lock = null
            let a_basic = null
            let b_basic = null
            let sort_fun = (a?, b?) => {
                if (is_fix) {
                    a_basic = goods_model.GetGoodsBasicByTypeId(a[1])
                    b_basic = goods_model.GetGoodsBasicByTypeId(b[1])
                    if (a_basic && b_basic) {
                        return b_basic.color > a_basic.color
                    }
                } else {
                    if (a[0] && b[0]) {
                        a_basic = goods_model.GetGoodsBasicByTypeId(a[0][1])
                        b_basic = goods_model.GetGoodsBasicByTypeId(b[0][1])
                        if (a_basic && b_basic) {
                            return b_basic.color > a_basic.color
                        }
                    }
                }
            }
            table.sort(list, sort_fun)

            if (is_fix) {
                str = "开启固定获得以下奖励：<br>";
                if (!isList) {
                    for (let _tmpi in list) {
                        let vo = list[_tmpi]
                        let [vo_type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
                        if (vo_type_id) {
                            basic_goods = goods_model.GetGoodsBasicByTypeId(vo_type_id)
                            if (basic_goods) {
                                str = str + "<font color=" + ColorUtil.GetColorDark(basic_goods.color) + ">" + basic_goods.goods_name + " * " + vo[2] + "</font><br>"
                            }
                        }
                    }
                }
            } else {
                str = "开启可随机获得<font color='#639c12'>" + times + "</font>个以下奖励内容:<br>";
                if (!isList) {
                    for (let _tmpi in list) {
                        let vo = list[_tmpi]
                        let [vo_type_id, lock] = goods_model.GetMappingTypeId(vo[0][0], vo[0][1])
                        if (vo_type_id) {
                            basic_goods = goods_model.GetGoodsBasicByTypeId(vo_type_id)
                            if (basic_goods) {
                                str = str + "<font color=" + ColorUtil.GetColorDark(basic_goods.color) + ">" + basic_goods.goods_name + " * " + vo[0][2] + "</font><br>"
                            }
                        }
                    }

                }
            }
        }
        return str
    }

    public Open(...parms) {
        [this.itemId, this.goods, this._data, this.isUseBtn, this.goodsNum] = [...parms];
        super.Open();
    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }

        if (this.tween_id) {
            this.tween_id = null;
        }

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }

        ResManager.GetInstance().ClearRoleMode(this.$hashCode);
        super.DeleteMe()
    }

    bgImg: Laya.Image
    bg1Img: Laya.Image
    quaImg: Laya.Image
    goods_name: Laya.Label
    iconBox: Laya.Box
    type_text: Laya.HTMLDivElement
    quantity_text: Laya.HTMLDivElement
    level_text: Laya.HTMLDivElement
    detail_scroller: Laya.Panel
    Content: Laya.VBox
    _Group1: Laya.Box
    _Image1: Laya.Image
    label1: Laya.Label
    intro: Laya.HTMLDivElement
    rewardsList: Laya.List
    useBtn: Laya.Box
    descLab: Laya.Label
    descHtml: Laya.HTMLDivElement
    titleImg: Laya.Image
    modelBox: Laya.Box
    lImg: Laya.Image
    rImg: Laya.Image
    iconImg: Laya.Image
    probabilityImg: Laya.Image
    jackpotImg: Laya.Image
    public GetComponents() {
        [
            this.bgImg,
            this.bg1Img,
            this.quaImg,
            this.goods_name,
            this.iconBox,
            this.type_text,
            this.quantity_text,
            this.level_text,
            this.detail_scroller,
            this.Content,
            this._Group1,
            this._Image1,
            this.label1,
            this.intro,
            this.rewardsList,
            this.useBtn,
            this.descLab,
            this.descHtml,
            this.titleImg,
            this.modelBox,
            this.lImg,
            this.rImg,
            this.iconImg,
            this.probabilityImg,
            this.jackpotImg,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "bg1Img",
                "quaImg",
                "goods_name",
                "iconBox",
                "type_text",
                "quantity_text",
                "level_text",
                "detail_scroller",
                "Content",
                "_Group1",
                "_Image1",
                "label1",
                "intro",
                "rewardsList",
                "useBtn",
                "descLab",
                "descHtml",
                "titleImg",
                "modelBox",
                "lImg",
                "rImg",
                "iconImg",
                "probabilityImg",
                "jackpotImg",
            ])
        this.type_text.style.fontSize = 24;
        this.type_text.style.color = "#FFFFFF";
        this.type_text.style.wordWrap = false

        this.quantity_text.style.fontSize = 24;
        this.quantity_text.style.color = "#FFFFFF";
        this.quantity_text.style.wordWrap = false

        this.level_text.style.fontSize = 22;
        this.level_text.style.color = "#FFFFFF";
        this.level_text.style.wordWrap = false

        this.intro.style.fontSize = 20;
        this.intro.style.bold = true
        this.intro.style.color = '#663915'

        // this.detail_scroller.vScrollBarSkin = '';

        this.descHtml.style.fontSize = 20;
        this.descHtml.style.color = "#ff4f50";
        this.descHtml.style.align = "center";
    }
}
window["ItemInfoTips"] = ItemInfoTips