import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { UIToolTipMgr } from '../common/UIToolTipMgr';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel } from '../commonModel/GuildModel';
import { ColorUtil, Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { TimeUtil } from '../util/TimeUtil';
import { HtmlColorTxt, Util } from '../util/Util';

export class GuildDepotRecordItem extends BaseItemRenderer {
    _model: GuildModel;
    data: ArrayElement<ProtoRecvVObj<40101>['exchange_records']>;
    public WIDTH = 665;
    public HEIGT = 30;
    is_set = false;
    public constructor() {
        super();
        this._model = GuildModel.GetInstance();
        this.base_file = 'guild';
        this.layout_file = 'GuildDepotRecordItem';
        this.load_callback = () => {
            this._lb_content.on(Laya.Event.LINK, this, this.ClickFunc);
            if (!this.is_set) {
                this.is_set = true;
                this.SetData();
            }

            Util.AddClickEvent(
                this.euqip,
                () => {
                    if (this.data) {
                        this.ClickFunc(this.data.id);
                    }
                },
                this,
                true
            );
        };
        this.Load();
    }

    PreSetHtml = () => {
        this._lb_content.width = 310;
        this._lb_content.style.fontSize = 20;
        this._lb_content.style.color = '#663915';
        //this._lb_content.style.wordWrap = true
        this._lb_content.style.leading = 4;

        // this.euqip.width = 310
        // this.euqip.style.fontSize = 20
        // this.euqip.style.color = "#663915"
        // //this.euqip.style.wordWrap = true
        // this.euqip.style.leading = 4
    };

    public dataChanged() {
        if (!super.dataChanged()) return;
        if (this.is_loaded) {
            this.is_set = true;
            this.SetData();
        } else {
            this.is_set = false;
        }
    }

    public SetData() {
        if (!this.data) return;
        this.PreSetHtml();
        let info = this.data;

        this._lb_content.innerHTML = `[${TimeUtil.timeConversion(info.time, 'mm-dd hh.MM')}]&nbsp;${info.role_name ? HtmlColorTxt(info.role_name, Enum_ColorUtil_Dark.GREEN) : '结社仓管'}&nbsp;${this.GetRecordTypeTxt(info)}&nbsp;`;
        //"[" + TimeUtil.timeConversion(info.time, "mm-dd hh.MM") + "]" + HtmlColorTxt(info.role_name, Enum_ColorUtil_Dark.GREEN) + this.GetRecordTypeTxt(info.exchange_type)
        let colorstr = ColorUtil.GetReplaceChar(ColorUtil.GetColorDark(info.color));
        this.euqip.color = colorstr;
        this.euqip.underlineColor = colorstr;
        this.euqip.text = GoodsModel.GetGoodsName(info.type_id) + '';
        this.euqip.x = this._lb_content.contextWidth + 2;

        // this.ReplaceUIShader(this.euqip)
    }

    public DeleteMe() {
        if (this._lb_content) {
            this._lb_content.off(Laya.Event.LINK, this, this.ClickFunc);
        }
        super.DeleteMe();
    }

    public ClickFunc(id?) {
        let info = this.GetRecordById(id);
        if (info) {
            this.RecordClickCallBack(info);
        }
    }

    public GetRecordById(id?) {
        let depot_info = this._model.GetDepotInfo();
        if (!depot_info) {
            return;
        }
        for (let _tmpi in depot_info.exchange_records) {
            var info = depot_info.exchange_records[_tmpi];
            if (info.id == id) {
                return info;
            }
        }
    }

    public RecordClickCallBack(info?) {
        if (info.type == 10) {
            UIToolTipMgr.GetInstance().AppendEquipTips(info.type_id, null, null, info);
        } else {
            UIToolTipMgr.GetInstance().AppendGoodsTips(info.type_id);
        }
    }

    public GetRecordTypeTxt(info?) {
        let type = info.exchange_type;
        if (type == 1) {
            return '捐献';
        } else if (type == 2) {
            return '兑换';
        } else if (type == 3) {
            return info.role_name ? '清理' : '自动清理';
        }
    }
    _lb_content: Laya.HTMLDivElement;
    euqip: Laya.Label;
    public GetComponents() {
        [this._lb_content, this.euqip] = this.GetChildrenByNames(['_lb_content', 'euqip']);
    }
}
window['GuildDepotRecordItem'] = GuildDepotRecordItem;
