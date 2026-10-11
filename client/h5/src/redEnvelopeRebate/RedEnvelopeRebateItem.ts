
import { Alert, Alert_Type } from '../alert/Alert';
import { BaseAwardItem } from '../common/BaseAwardItem';
import { OpenFun } from '../common/OpenFun';
import { ResManager } from '../common/ResManager';
import { WordManager } from '../common/WordManager';
import { ActivityIconManager } from '../commonModel/ActivityIconManager';
import { CustomActivityDefine } from '../commonModel/CustomActivityDefine';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { EnumRedEvnelopeRebateViewType, IS2CRedEvnelopeRebateParam, RedEnvelopeRebateModel } from '../commonModel/RedEnvelopeRebateModel';
import { Message } from '../sysInfo/SysInfoController';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
import { ErlangParser } from './../util/ErlangParser';
export class RedEnvelopeRebateItem extends BaseItem1 {


    private _item: BaseAwardItem;
    private _info: any;
    private day: number = 0;
    private index: number = 0;
    private type: number = 0;
    private get RedEnvelopeRebateModel() {
        return RedEnvelopeRebateModel.GetInstance();
    }

    public constructor(parent?) {
        super(parent)
        this.base_file = "redEnvelopeRebate"
        this.layout_file = "RedEnvelopeRebateItem"

        this.load_callback = () => {
            if (this._item) {
                this._item.DeleteMe();
                this._item = null;
            }
            this.InitEvent();
            this.LoadSuccess();
        }
    }



    public InitEvent() {
        let ClickItem = () => {
            let actData: IS2CRedEvnelopeRebateParam = this.RedEnvelopeRebateModel.actData;
            if (this._info && actData) {
                if (this._info.status == 1) {
                    CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, actData.type, actData.subtype, this._info.grade)
                } else if (this._info.status == 3) {
                    Message.show(`奖励已过期`)
                } else if (this._info.status == 2) {
                    Message.show(`奖励已领取`)
                } else {
                    if (this.type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope) {
                        Message.show(`第${WordManager.NumConvertStage(this.day)}天可领取`)
                    } else {
                        Alert.Show("充值1元可获现金红包和道具奖励<br>", Alert_Type.One, () => {
                            OpenFun.OpenFunHandler(Boolean(ActivityIconManager.GetInstance().getIconInfo('331@115@0')) ? 332115 : 21);
                        }, undefined, "前往充值");
                    }
                }
            }
        }


        // 点击领取奖励
        Util.AddClickEvent(this.itemBox, ClickItem, this, true);

    }

    public DeleteMe() {
        if (this._item) {
            this._item.DeleteMe();
            this._item = null;
        }
        super.DeleteMe();
    }

    public SetData(info: any, index: number) {
        this._info = info;
        this.index = index;
        if (this.is_loaded) {
            this.RenderView();
        }
    }

    public LoadSuccess() {
        this.RenderView();
    }

    private RenderView() {
        if (!this._info || !this.is_loaded) {
            return;
        }

        if (!this._item) {
            this._item = new BaseAwardItem(this.iconBox, null, null, false);
        }
        let reward = ErlangParser.GetInstance().parse(this._info.reward)[0];
        let condition = ErlangParser.GetInstance().parse(this._info.condition);
        let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
        let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
        if (goods_vo) {
            let num = (reward[2] == 1 && (null) || (reward[2]));
            this._item.SetData(goods_vo.type_id, num, lock);
            //  this.iconNameLab.text = goods_vo.goods_name;/*  : GoodsModel.GetGoodsName(type_id); */
            // this.iconNameLab.color = ColorUtil.GetColorDark(goods_vo.color, false); 
        }
        this._item.SetItemSize(85, 85);
        this._item.Load();

        let day: number = this.day = +condition[2][1];
        let type: number = this.type = +condition[4][1];
        let tag: number = +condition[3][1];
        this.dayLab.text = `第${WordManager.NumConvertStage(day)}天`;
        this.descLab.text = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? '登录即领' : '再赠红包';
        this.tipsImg.visible = tag > 0;
        let url: string = '';
        switch (tag) {
            case 1:
                url = 'ui_hb_08'
                break;
            case 2:
                url = 'ui_hb_09'
                break;
            case 3:
                url = 'ui_hb_10'
                break;
        }
        ResManager.GetInstance().SetImageSpriteTrans(
            this,
            this.tipsImg,
            GameResPath.GetIcon('redEnvelopeRebate', url)
        );

        // 状态
        this.redImg.visible = this._info.status == 1; // 可领取有红点
        this.getImg.visible = this._info.status == 2; // 已领取
        this.expiredImg.visible = this._info.status == 3; // 未领取已过期
        this.bgImg.visible = this._info.status >= 2;

    }






    itemBox: Laya.Box
    dayLab: Laya.Label
    iconBox: Laya.Box
    descLab: Laya.Label
    tipsImg: Laya.Image
    bgImg: Laya.Image
    expiredImg: Laya.Image
    getImg: Laya.Image
    redImg: Laya.Image
    public GetComponents() {
        [
            this.itemBox,
            this.dayLab,
            this.iconBox,
            this.descLab,
            this.tipsImg,
            this.bgImg,
            this.expiredImg,
            this.getImg,
            this.redImg,
        ]
            = this.GetChildrenByNames([

                "itemBox",
                "dayLab",
                "iconBox",
                "descLab",
                "tipsImg",
                "bgImg",
                "expiredImg",
                "getImg",
                "redImg",
            ])
    }
}
window["RedEnvelopeRebateItem"] = RedEnvelopeRebateItem