
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { HtmlColorTxt, PlayBigEffect, RefGridLayout, SetHtmlCenter, Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
import { EnumPushGiftType, PushGiftModel } from '../commonModel/PushGiftModel';
import { GiftPushIcon } from '../mainUI/GiftPushIcon';
import { EnumSubType, IS2CSuitListInfoParam, SuitModel, SuitModelEvent } from '../commonModel/SuitModel';
import { EquipSuitPosItem } from './EquipSuitPosItem';
import { EquipmentItem } from '../common/EquipmentItem';
import { Config } from "../common/Config"
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { EquipEvent, EquipModel } from '../commonModel/EquipModel';
import { WordManager } from './../common/WordManager';
import { ColorUtil, Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { EquipSuitCostItem } from './EquipSuitCostItem';
import { Message } from '../sysInfo/SysInfoController';
import { EquipNewSuitAttrItem } from './EquipNewSuitAttrItem';
import { EquipSuitPreviewTips } from './EquipSuitPreviewTips';
import { Alert, Alert_Type } from '../alert/Alert';

export class EquipSuitMianView extends BaseItem1 {
    public static readonly _layout_file: string = 'EquipSuitMianView';

    private loop_mgr: LoopScrowViewMgr;
    private loop_mgr1: LoopScrowViewMgr;
    private loop_mgr2: LoopScrowViewMgr;
    private defSelectPos: number = 0;
    private defSelectData: any;

    private _itemUp: EquipmentItem;
    private _itemDown: EquipmentItem;
    private costItemList: EquipSuitCostItem[] = [];

    // 套装子类型
    private subType: number = 1;
    //套装类型  1 武防 2 饰品
    private suitType: number = 1;
    private curAttrIndex: number = 0;
    private confAttrs: any[];
    private giftItem: GiftPushIcon;
    private tipsDesc: string = '';
    private changeTab: boolean = false;

    private get suitModel() {
        return SuitModel.GetInstance();
    }

    public constructor(parent?: any) {
        super(parent);

        this.base_file = 'suit';
        this.layout_file = 'EquipSuitMianView';
        this.layer_value = Enum_UILayer.Activity;

        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };
    }

    // 参数
    public CustomMehod(index?, parms?) {
        [this.suitType, this.subType] = [...parms];
    }

    private LoadSuccess() {
        this.RenderEquipList();
        this.ShowGiftIcon();
    }

    public InitEvent() {
        this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
            this.ShowGiftIcon();
        });

        // 选择部位回调
        this.BindEvent(this.suitModel, SuitModelEvent.TAB_SELECT, (data?: any, index?: number) => {
            this.defSelectPos = index;
            this.defSelectData = data;
            this.loop_mgr.SetSelectIndex(this.defSelectPos);
            this.RenderSelectPos();
        });

        // 查看说明
        Util.AddClickEvent(this.infoBox, () => {
            GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.EquipSuit);
        }, this, true);

        // 查看预览
        Util.AddClickEvent(this.previewBox, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, EquipSuitPreviewTips._layout_file, this.defSelectData, this.suitType, this.subType);
        }, this, true);

        // 共鸣回退
        Util.AddClickEvent(
            this._btn_back, () => {
                if (!this.defSelectData) {
                    return;
                }
                let dynamic = this.defSelectData.dynamic;
                EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipSuitReturnView", dynamic, this.suitType, this.subType);
            },
            this,
            true
        );

        // 点击打造 
        Util.AddClickEvent(
            this.upBtn, () => {
                if (!this.defSelectData) {
                    Message.show("当前未穿戴装备");
                    return;
                }
                // 装备是否满足条件
                if (this.tipsDesc) {
                    Message.show(this.tipsDesc);
                    return;
                }
                let pos: number = this.defSelectData.equip_type;
                let isRed: boolean = this.suitModel.GetSuitTypeSubTypePosRed(this.suitType, this.subType, pos);
                let isShow: boolean = this.suitModel.GetSuitTypeSubTypePosShowRed(this.suitType, this.subType, pos);

                if (isRed && !isShow) {
                    let str = this.suitModel.GetIsEquip(pos) ? "2/4/6" : "2/3/4";
                    str = Util.HtmlColorTxt(`${str}件相同级数`, Enum_ColorUtil_Dark.RED)
                    str = `当前操作可能会导致战力降低，是否确认继续？<br>(推荐同时打造${str}的套装)`
                    Alert.Show(Util.StrToHTML(str), Alert_Type.Two, () => {
                        EquipModel.GetInstance().Fire(EquipEvent.REQUEST_PROTO, 15221, "cc", this.subType, this.defSelectData.equip_type);
                    })
                } else {
                    EquipModel.GetInstance().Fire(EquipEvent.REQUEST_PROTO, 15221, "cc", this.subType, this.defSelectData.equip_type);

                }

            },
            this,
            true
        )

        // 点击查看下一个套属性
        Util.AddClickEvent(this.rImg, () => {
            if (this.curAttrIndex >= this.confAttrs.length - 1) {
                return Message.show('已经是最高级')
            }
            this.ClickRight();
        }, this, true);

        // 点击查看上一个套属性
        Util.AddClickEvent(this.lImg, () => {
            if (this.curAttrIndex <= 0) {
                return Message.show('已经是最低级')
            }
            this.ClickLeft();
        }, this, true);

        // 打造回调
        this.BindEvent(
            this.suitModel,
            SuitModelEvent.UP_SUIT_SUCCESS, () => {
                PlayBigEffect("ui_gongmingchenggong");
                // this.AddUIEffect("ui_gongmingchenggong", this._group_eff, undefined, 4, false, 1, undefined, undefined, undefined, undefined, undefined, undefined, false)
                // this.ClearUIEffect(this._group_eff1);
                // this._group_eff1.visible = true;
                // this.AddUIEffect("QiangHua", this._group_eff1, { x: -1, y: -1 }, 7, false, 0.5, () => {
                //     this._group_eff1.visible = false;
                // });
                this.RenderEquipList();
            }
        )

        // 打造回退
        this.BindEvent(
            this.suitModel,
            SuitModelEvent.BACK_SUIT_SUCCESS, () => {
                this.RenderEquipList();
            }
        )

        // 页签更变
        this.BindEvent(GlobalEventSystem, EventName.CHANGE_SUB_VIEW, (view_name: string, index: number) => {
            if (view_name == this.layout_file) {
                [this.suitType, this.subType] = [...this.suitModel.GetSuitTypeAndSubTypeList()[index]];
                this.ChangeTab();
            }
        });

    }


    /**
     * 渲染装备列表
     */
    private RenderEquipList() {
        let equips = this.suitModel.GetEquipInfos(this.suitType, this.subType);
        if (this.defSelectPos && this.defSelectData) {
            // 先判断自身选中是否还有红点
            if (this.suitModel.GetSuitTypeSubTypePosShowRed(this.suitType, this.subType, this.defSelectData.equip_type)) {
                this.loop_mgr.replaceAll(equips);
                this.RenderSelectPos();
                return;
            }
        }
        this.ChangeTab();
    }

    private ChangeTab() {
        let equips = this.suitModel.GetEquipInfos(this.suitType, this.subType);

        // 选中有红点
        let redindex: number = equips.findIndex((equip: any) => {
            return this.suitModel.GetSuitTypeSubTypePosShowRed(this.suitType, this.subType, equip.equip_type);
        });

        let defIndex: number = Math.max(redindex, 0);
        this.defSelectPos = defIndex;


        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr()
            this.loop_mgr.SetData(this.posList, EquipSuitPosItem, equips, LoopScrCon.Vertical, 1)
        } else {
            this.loop_mgr.replaceAll(equips);
        }
        let equip = equips[defIndex];
        this.loop_mgr.SetSelectIndex(this.defSelectPos);
        this.defSelectData = equip;
        this.RenderSelectPos();
    }


    /**
     * 渲染选中位置装备信息
     * @param data 
     */
    private RenderSelectPos() {
        this.tipsDesc = '';
        this.RenderUpIcon();
        this.RenderDownIcon();
        this.RenderSuitCost();
        this.RenderDefAttrs();
    }

    /**
     * 渲染上面的icon
     */
    private RenderUpIcon() {
        if (!this.defSelectData || !this.defSelectData.dynamic) {
            return;
        }
        if (!this._itemUp) {
            this._itemUp = new EquipmentItem(this.iconSBox);
            this._itemUp.Load();
        }
        let data = this.defSelectData;
        let typeId: number = this.defSelectData.dynamic.type_id;

        this._itemUp.SetShowTips(false);
        this._itemUp.SetItemSize(85, 85);
        this._itemUp.SetData(typeId);
        let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, typeId, false);
        let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(this.suitType, this.subType, data.equip_type);
        let conf = this.suitModel.GetConfSuitItemInfo(this.suitType, this.subType, (suit?.slv || 0));

        let titleStr: string
        let sLabX = 0
        if(conf?.name){
            sLabX = -5
            titleStr = HtmlColorTxt((conf?.name || ''), this.suitModel.GetColorByType(this.suitType, this.subType));
        }
        else{
            titleStr = ""
        }
        this.nameSLab.innerHTML = titleStr + goods.goods_name.replace("(残)", "");
        SetHtmlCenter(this.nameSLab, { x: sLabX, w: 260 })

        this._btn_back.visible = suit?.slv >= 1;
    }

    /**
     * 渲染下面的icon
     */
    private RenderDownIcon() {
        if (!this.defSelectData || !this.defSelectData.dynamic) {
            return;
        }
        
        let equipModel: EquipModel = EquipModel.GetInstance();
        if (!this._itemDown) {
            this._itemDown = new EquipmentItem(this.iconXBox);
            this._itemDown.Load();
        }
        let typeId: number = this.defSelectData.dynamic.type_id;
        let dynamic = this.defSelectData.dynamic;
        let data = this.defSelectData;

        this._itemDown.SetShowTips(false);
        this._itemDown.SetItemSize(85, 85);
        this._itemDown.SetData(typeId);

        let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, typeId, false);
        let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(this.suitType, this.subType, dynamic.equip_type);
        let conf = this.suitModel.GetConfSuitItemInfo(this.suitType, this.subType, (suit?.slv || 0) + 1);
        let isMax: boolean = suit?.slv && !conf;
        
        let titleStr: string 
        let xLabX = 0
        if(conf?.name){
            xLabX - 5
            titleStr = HtmlColorTxt((conf?.name || ''), this.suitModel.GetColorByType(this.suitType, this.subType));
        }
        else{
            titleStr = ""
        }
        this.nameXLab.innerHTML = isMax ? '已满阶' : titleStr + goods.goods_name.replace("(残)", "");
        SetHtmlCenter(this.nameXLab, { w: 260, x: xLabX })

        this.descBox.visible = !isMax;
        if (!isMax) {
            let makeCfg = this.suitModel.GetConfSuitMakeInfo(data.equip_type, this.subType, (suit?.slv || 0) + 1);
            if (makeCfg) {
                let conditionList = JSON.parse(makeCfg.condition)
                // 先判断是否满足条件
                let needQua: number = conditionList[0][1]; // 需要达到品质
                let needStar: number = conditionList[0][2]; // 需要达到星级
                let needOrder: number = conditionList[1][2]; // 需要达到阶数

                let meStar: number = equipModel.GetStarByTypeId(dynamic.type_id);
                let meOrder: number = EquipModel.GetInstance().GetStageByTypeId(dynamic.type_id);

                let isNeed: boolean = needQua > dynamic.color || needStar > meStar || needOrder > meOrder;
                // 判断品质/星级/阶数
                if (isNeed) {
                    let orderStr: string = HtmlColorTxt(WordManager.NumConvertStage(needOrder) + '阶', Enum_ColorUtil_Dark.GREEN);
                    let quaStr: string = HtmlColorTxt(ColorUtil.GetColorName(needQua), Enum_ColorUtil_Dark.GOLDEN);
                    let starStr: string = HtmlColorTxt(WordManager.NumConvertStage(needStar) + '星', Enum_ColorUtil_Dark.GOLDEN);
                    this.descHtml.innerHTML = `穿戴${orderStr}${quaStr}${starStr}装备可打造`;
                    this.descHtml.style.width = 320;
                    this.descHtml.x = 65;
                    this.tipsDesc = `穿戴${WordManager.NumConvertStage(needOrder)}阶${ColorUtil.GetColorName(needQua)}${WordManager.NumConvertStage(needStar)}星装备可打造`;
                } else {
                    this.descHtml.innerHTML = '打造消耗';
                    this.descHtml.style.width = 120;
                    this.descHtml.x = 165;
                }

                let confMaxSuitLv = this.suitModel.GetConfEquipMaxSuitLv(data.equip_type, this.suitType, this.subType);
                let bool: boolean = this.suitModel.GetIsEquip(data.equip_type) && Boolean(confMaxSuitLv && confMaxSuitLv.slv > (suit?.slv || 1) && meOrder >= needOrder)
                this.previewBox.visible = bool;

                // 判断下一级是否显示特效
                if ((((confMaxSuitLv?.slv || 0) >= 1) || !isNeed) && makeCfg.slv >= (confMaxSuitLv?.slv || 1)) {
                    this.effBox2.visible = true;
                    this.RednerEffAni(this.effBox2);
                } else {
                    this.effBox2.visible = false;
                }

                // 判断当期级是否显示特效
                let isMake: boolean = this.suitModel.GetSuitMakeConditionsState(this.suitType, this.subType, data.equip_type);
                if (isMake && ((suit?.slv || 0) >= (confMaxSuitLv?.slv || 1))) {
                    this.effBox1.visible = true;
                    this.RednerEffAni(this.effBox1);
                } else {
                    this.effBox1.visible = false;
                }
            }
        } else {
            this.previewBox.visible = false;
        }

    }

    /**
     * 渲染打造消耗
     */
    private RenderSuitCost() {
        let data = this.defSelectData;
        let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(this.suitType, this.subType, data.equip_type);
        let costs = this.suitModel.GetSuitMakeCost(data.equip_type, this.subType, (suit?.slv || 0) + 1);

        if (!this.loop_mgr2) {
            this.loop_mgr2 = new LoopScrowViewMgr()
            this.loop_mgr2.SetData(this.costList, EquipSuitCostItem, costs, LoopScrCon.Horizontal, 1);
        } else {
            this.loop_mgr2.replaceAll(costs);
        }

        // 计算位置
        let len: number = costs.length > 3 ? 3 : costs.length;
        let spaceNum: number = len > 1 ? len - 1 : 0;
        let w: number = len * 100 + spaceNum * this.costList.spaceX;
        this.costList.width = w;

        this.UpdateRedDot();
    }

    /**
     * 渲染属性
     */
    private RenderDefAttrs() {
        this.confAttrs = this.suitModel.GetConfSuitItemListBySuitTypeAndSubType(this.suitType, this.subType);
        let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(this.suitType, this.subType, this.defSelectData.equip_type);
        let curSuitLv: number = suit?.slv || 0;
        let index: number = this.confAttrs.findIndex((conf: any) => {
            return curSuitLv == conf.slv;
        });
        this.curAttrIndex = Math.max(index, 0);
        this.RenderAttrsList();
    }

    /**
     * 渲染属性列表
     */
    private RenderAttrsList() {
        let conf: any = this.confAttrs[this.curAttrIndex];
        let attrs: any[] = JSON.parse(conf.attr_list);

        for (const iterator of attrs) {
            iterator.suitType = this.suitType;
            iterator.subType = this.subType;
            iterator.pos = this.defSelectData.equip_type;
            iterator.lv = conf.slv;
        }

        if (!this.loop_mgr1) {
            this.loop_mgr1 = new LoopScrowViewMgr()
            this.loop_mgr1.SetData(this.atrsList, EquipNewSuitAttrItem, attrs);
        } else {
            this.loop_mgr1.replaceAll(attrs);
        }

        let curNum: number = this.suitModel.GetTypePosLevelNum(this.suitType, this.subType, this.defSelectData.equip_type.pos, conf.slv);
        this.barLab.text = `(${curNum}/${conf.max_count})`;
        this.nameLab.text = `${conf.name}`;
        this.nameLab.color = ColorUtil.GetReplaceChar(this.suitModel.GetColorByType(this.suitType, this.subType));
        // 套装战力
        EquipModel.GetInstance().Fire(EquipEvent.REQUEST_PROTO, 15262, "cch", this.defSelectData.equip_type, this.subType, this.curAttrIndex + 1);

    }

    private RednerEffAni(box: Laya.Box) {
        let effName: string = this.suitModel.GetEffNameByType(this.suitType, this.subType);
        let bool: boolean = box.name == this.effBox2.name;
        box.x = bool ? 84 : 64;
        box.y = bool ? 57 : 27;
        let pos: { x: number, y: number } = { x: 0, y: 0 };
        switch (this.suitModel.GetSubTypeByEffName(effName)) {
            case EnumSubType.eOne:
                box.scaleX = 1;
                box.scaleY = 1;
                break;
            case EnumSubType.eTwo:
                box.scaleX = 1.2;
                box.scaleY = 1;
                pos.x = -0.1;
                break;
            case EnumSubType.eThree:
                box.scaleX = 1.2;
                box.scaleY = 1.2;
                break;
        }

        // this.ClearUIEffect(box);
        this.AddUIEffect(effName, box, pos, 10, true);
    }


    private ClickRight() {
        let index: number = this.curAttrIndex + 1;
        if (index <= this.confAttrs.length - 1) {
            this.curAttrIndex = index;
            this.RenderAttrsList();
        }
    }

    private ClickLeft() {
        let index: number = this.curAttrIndex - 1;
        if (index >= 0) {
            this.curAttrIndex = index;
            this.RenderAttrsList();
        }
    }


    /**
     * 打造红点
     */
    private UpdateRedDot() {
        let pos: number = this.defSelectData.equip_type;
        let isRed: boolean = this.suitModel.GetSuitTypeSubTypePosRed(this.suitType, this.subType, pos);
        let isShow: boolean = this.suitModel.GetSuitTypeSubTypePosShowRed(this.suitType, this.subType, pos);
        let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(this.suitType, this.subType, pos);
        let isCost: boolean = !this.suitModel.GetSuitMakeCostState(pos, this.subType, (suit?.slv || 0) + 1);
        // 红点
        this.redImg.visible = isShow;
        this.upBtn.gray = !(isRed);
        if (!this.suitModel.GetSuitMakeCostState(pos, this.subType, (suit?.slv || 0) + 1) && !Boolean(this.tipsDesc)) {
            this.tipsDesc = '物品不足';
            this.upBtn.gray = false;
        }

        this.upBtn.mouseEnabled = (isRed || isShow || Boolean(this.tipsDesc));

    }




    private ShowGiftIcon() {
        let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eGongMing));
        if (bool) {
            if (!this.giftItem) {
                this.giftItem = new GiftPushIcon(this.giftIcon);
                this.giftItem.Load();
            }
            this.giftItem.ExcuteCallback(() => {
                this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eGongMing, 0);
            });
        }
        this.giftIcon.visible = bool;
    }


    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }

        if (this.giftItem) {
            this.giftItem.DeleteMe();
            this.giftItem = null;
        }

        if (this._itemUp) {
            this._itemUp.DeleteMe();
            this._itemUp = null;
        }

        if (this._itemDown) {
            this._itemDown.DeleteMe();
            this._itemDown = null;
        }

        this.ClearUIEffect(this.effBox1);
        this.ClearUIEffect(this.effBox2);

        for (let index = 0; index < this.costItemList.length; index++) {
            this.costItemList[index].DeleteMe();
        }
        this.costItemList = [];
        this.defSelectData = null;
        this.tipsDesc = '';

        super.DeleteMe();
    }

    iconSBox: Laya.Box
    iconXBox: Laya.Box
    nameSLab: Laya.HTMLDivElement
    nameXLab: Laya.HTMLDivElement
    _btn_back: Laya.Box
    descBox: Laya.Box
    descHtml: Laya.HTMLDivElement
    previewBox: Laya.Box
    infoBox: Laya.Box
    costList: Laya.List
    nameLab: Laya.Label
    barLab: Laya.Label
    lImg: Laya.Image
    rImg: Laya.Image
    atrsList: Laya.List
    maxImg: Laya.Image
    posList: Laya.List
    upBtn: Laya.Box
    redImg: Laya.Image
    giftIcon: Laya.Box
    _group_eff: Laya.Box
    effBox1: Laya.Box
    effBox2: Laya.Box
    public GetComponents() {
        [
            this.iconSBox,
            this.iconXBox,
            this.nameSLab,
            this.nameXLab,
            this._btn_back,
            this.descBox,
            this.descHtml,
            this.previewBox,
            this.infoBox,
            this.costList,
            this.nameLab,
            this.barLab,
            this.lImg,
            this.rImg,
            this.atrsList,
            this.maxImg,
            this.posList,
            this.upBtn,
            this.redImg,
            this.giftIcon,
            this._group_eff,
            this.effBox1,
            this.effBox2,
        ]
            = this.GetChildrenByNames([

                "iconSBox",
                "iconXBox",
                "nameSLab",
                "nameXLab",
                "_btn_back",
                "descBox",
                "descHtml",
                "previewBox",
                "infoBox",
                "costList",
                "nameLab",
                "barLab",
                "lImg",
                "rImg",
                "atrsList",
                "maxImg",
                "posList",
                "upBtn",
                "redImg",
                "giftIcon",
                "_group_eff",
                "effBox1",
                "effBox2",
            ]);
        this.descHtml.style.fontSize = 20;
        this.descHtml.style.color = '#663915';
        this.descHtml.style.height = 22;
        this.descHtml.style.align = 'center';

        this.nameSLab.style.fontSize = 22;
        this.nameSLab.style.color = '#9E443A';
        this.nameSLab.style.wordWrap = false;

        this.nameXLab.style.fontSize = 22;
        this.nameXLab.style.color = '#9E443A';
        this.nameXLab.style.wordWrap = false;
    }
}
window["EquipSuitMianView"] = EquipSuitMianView