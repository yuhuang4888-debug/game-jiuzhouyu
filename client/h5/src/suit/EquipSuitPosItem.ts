import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { GameResPath } from './../util/GameResPath';
import { Config } from "../common/Config"
import { EquipDefine, EquipModel } from "../commonModel/EquipModel";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { IS2CSuitListInfoParam, SuitModel, SuitModelEvent } from './../commonModel/SuitModel';
import { Util } from "../util/Util";
import { Message } from "../sysInfo/SysInfoController";

export class EquipSuitPosItem extends BaseItemRenderer {

    public WIDTH = 112;
    public HEIGT = 200;

    private _item: EquipmentItem;

    private get suitModel() {
        return SuitModel.GetInstance();
    }

    public constructor() {
        super();
        this.base_file = "suit";
        this.layout_file = "EquipSuitPosItem";

        this.load_callback = () => {
            this.InitEvents();
            this.LoadSuccess();
        }
        this.Load();

    }

    private InitEvents() {
        // 点击页签
        let ClickTab = () => {
            if (this.data) {
                if (this.data.is_empty) {
                    Message.show('请先穿戴装备');
                    return;
                }
                this.suitModel.Fire(SuitModelEvent.TAB_SELECT, this.data, this.index);
            }
        }
        Util.AddClickEvent(this.itemBox, ClickTab, this, true);
    }

    private LoadSuccess() {
        if (!this._item) {
            this._item = new EquipmentItem(this.iconBox, null, null, null, null, true);
            this._item.SetItemSize(77, 77);
            this._item.SetUseMask(true)
            this._item.Load();
        }
    }

    public DeleteMe() {
        if(this._item){
            this._item.DeleteMe()
            this._item = undefined
        }
        super.DeleteMe();
    }


    public dataChanged() {
        if (super.dataChanged()) {
            if (!this.data) {
                return;
            }
            let data = this.data;
            let dynamic = data.dynamic;
            if (!this._item) {
                this._item = new EquipmentItem(this.iconBox, null, null, null, null, true);
                this._item.Load();
            }

            // 选中
            this.defImg.visible = !this.selected;
            this.selectImg.visible = this.selected;

            // 判断是否穿戴装备
            if (data.is_empty) {
                this.descLab.visible = false;
                this.numLab.visible = false;
                this.redImg.visible = false;
                ResManager.GetInstance().SetImageSpriteTrans(this, this.iconImg, GameResPath.GetIcon('equipCom', 'role_default_' + data.equip_type))
                this.iconImg.visible = true;
                this.bgImg.visible = true;
                this.iconBox.visible = false;
                this.nameLab.visible = false;
                return;
            } else {
                this.nameLab.visible = true;
                this.descLab.visible = true;
                this.redImg.visible = false;
                this.iconImg.visible = false;
                this.bgImg.visible = false;
                this.iconBox.visible = true;
            }

            this._item.SetShowTips(false);
            this._item.SetItemSize(77, 77);
            this._item.SetData(dynamic.type_id, null, null, null, null, null, null, null, dynamic.goods_id);


            // 判断装备类型
            let equipModel: EquipModel = EquipModel.GetInstance();
            let suitType: number = EquipModel.GetInstance().GetSuitType(dynamic.equip_type);

            // 部位+共鸣类型+共鸣等级
            let suit: IS2CSuitListInfoParam = this.suitModel.GetSuitPos(suitType, data.subType, dynamic.equip_type);
            let makeCfg = this.suitModel.GetConfSuitMakeInfo(dynamic.equip_type, data.subType, (suit?.slv || 0) + 1);
            let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, dynamic.type_id, false);
            let conf = this.suitModel.GetConfSuitItemInfo(suitType, data.subType, (suit?.slv || 1));
            // 名字
            this.nameLab.text = goods.goods_name.replace("(残)", "");
            this.nameLab.color = ColorUtil.GetColorDark(goods.color, false);

            if (makeCfg) {
                let conditionList = JSON.parse(makeCfg.condition)
                // 先判断是否满足条件
                let needQua: number = conditionList[0][1]; // 需要达到品质
                let needStar: number = conditionList[0][2]; // 需要达到星级
                let needOrder: number = conditionList[1][2]; // 需要达到阶数
                this.numLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.GREEN);
                if (suit?.slv) {
                    // 装备数量
                    this.numLab.visible = true;
                    this.numLab.text = this.suitModel.GetTypePosLevelNum(suitType, data.subType, dynamic.equip_type, (suit?.slv || 1)) + '/' + conf.max_count;
                    this.descLab.valign = 'top';
                    this.descLab.text = conf?.name || '可打造';
                } else {
                    // 判断品质/判断星级/判断阶数
                    let meStar: number = equipModel.GetStarByTypeId(dynamic.type_id);
                    let meOrder: number = EquipModel.GetInstance().GetStageByTypeId(dynamic.type_id);
                    if (needQua > dynamic.color || needStar > meStar || needOrder > meOrder) {
                        let orderStr: string = meOrder >= needOrder ? '' : `${needOrder}阶`;
                        this.descLab.valign = 'top';
                        this.descLab.text = `不足${orderStr}${ColorUtil.GetColorNameOne(needQua)}${needStar}星`;
                        this.descLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED);
                        this.numLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED);
                        this.numLab.text = '无法打造';
                        this.numLab.visible = true;
                        return;
                    }

                    this.numLab.visible = false;
                    this.descLab.valign = 'middle';
                    this.descLab.text = '可打造';

                }

                this.descLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.GREEN);
                this.redImg.visible = this.suitModel.GetSuitTypeSubTypePosShowRed(suitType, data.subType, dynamic.equip_type)
            } else {
                this.descLab.valign = 'top';
                this.descLab.text = `不足${EquipDefine.EQUIP_SUIT_MIN_STAGE}阶`;
                this.descLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED);
                this.numLab.color = ColorUtil.GetReplaceChar(Enum_ColorUtil_Dark.RED);
                this.numLab.text = '无法打造';
                this.numLab.visible = true;
            }
        }
    }

    defImg: Laya.Image
    selectImg: Laya.Image
    iconBox: Laya.Box
    nameLab: Laya.Label
    descLab: Laya.Label
    numLab: Laya.Label
    redImg: Laya.Image
    bgImg: Laya.Image
    iconImg: Laya.Image
    itemBox: Laya.Box
    public GetComponents() {
        [
            this.defImg,
            this.selectImg,
            this.iconBox,
            this.nameLab,
            this.descLab,
            this.numLab,
            this.redImg,
            this.bgImg,
            this.iconImg,
            this.itemBox,
        ]
            = this.GetChildrenByNames([

                "defImg",
                "selectImg",
                "iconBox",
                "nameLab",
                "descLab",
                "numLab",
                "redImg",
                "bgImg",
                "iconImg",
                "itemBox",
            ])
    }
}
window["EquipSuitPosItem"] = EquipSuitPosItem