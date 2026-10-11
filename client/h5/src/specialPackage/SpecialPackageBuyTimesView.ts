import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SpecialPackageModel } from "../commonModel/SpecialPackageModel"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"

export class SpecialPackageBuyTimesView extends BaseView1 {
    public static readonly _cName: string = 'SpecialPackageBuyTimesView';
    private _type_: number = 0;
    private actData: any = null;
    private _sub_type_: number = 0;
    private actInfo: any = null;

    private get SpecialPackageModel() {
        return SpecialPackageModel.GetInstance();
    }


    public constructor() {
        super()
        this.base_file = "arena"
        this.layout_file = "ArenaBuyTimesView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true

        this.load_callback = () => {
            ResManager.GetInstance().SetTexture(this, this._Image10, GameResPath.GetIcon("arena", "com_tips"), null, null, true);
            this.InitEvent();
            this.SetData();
            this.RenderView();
        }

    }

    private InitEvent() {
        Util.AddClickEvent(this._btn_cancal, () => {
            this.Close();
        }, this, true)

        Util.AddClickEvent(this._btn_close, () => {
            this.Close();
        }, this, true)

        Util.AddClickEvent(this._btn_ok, () => {
            OpenFun.OpenFunHandler(23);
            this.Close();
        }, this, true);

        /*      this.BindVar(model, "times_info", (event_name?, value?, old_value?) => {
                 if (this.moudle_id == local_ArenaModel.MOUDLE_ID.Arena) {
                     this.can_buy_times = value.can_buy_num
                     this.UpdateView()
                 }
             }
             ) */
    }



    private RenderView() {
        let actInfo = ErlangParser.GetInstance().parse(this.actInfo.condition);
        let roleVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
        let actData = this.actData.reward_list[0];
        let vips = actInfo[2][1];
        let roleVipLv: number = roleVo.vip_flag;
        let vipAndTimes: { times: number, lv: number } = this.SpecialPackageModel.GetNextLvBuyTimes(vips, roleVipLv);
        this._lb_msg.innerHTML = `
        升至${HtmlColorTxt('V' + vipAndTimes.lv, ColorUtil.GetColorDark(ColorType.GREEN))}
        即可多购买${HtmlColorTxt(vipAndTimes.times, ColorUtil.GetColorDark(ColorType.GREEN))}件`;
        let totalNum: number = this.SpecialPackageModel.GetCurLvBuyTimes(vips, roleVipLv);
        let rtotalNum: number = this.SpecialPackageModel.GetCurLvBuyTimes(vips, vipAndTimes.lv);

        this._lb_lcount.innerHTML = `每天能购买${HtmlColorTxt(actData.receive_times, ColorUtil.GetColorDark(ColorType.RED))}
        /${HtmlColorTxt(totalNum, ColorUtil.GetColorDark(ColorType.GREEN))}件`;
        this._lb_rcount.innerHTML = `每天能购买${HtmlColorTxt(actData.receive_times, ColorUtil.GetColorDark(ColorType.GREEN))}
        /${HtmlColorTxt(rtotalNum, ColorUtil.GetColorDark(ColorType.GREEN))}件`;

        ResManager.GetInstance().SetImageSpriteTrans(this, this._img_lvip, GameResPath.GetIcon('common4', 'com_vip' + roleVipLv));
        ResManager.GetInstance().SetImageSpriteTrans(this, this._img_rvip, GameResPath.GetIcon('common4', 'com_vip' + vipAndTimes.lv));

    }

    private SetData() {
        this.actData = CustomActivityModel.GetInstance().GetActData(this._type_, this._sub_type_);
        this.actInfo = CustomActivityModel.GetInstance().GetActInfo(this._type_, this._sub_type_);
    }


    public Open(...new_args) {
        this._type_ = new_args[0];
        this._sub_type_ = new_args[1];
        super.Open();
    }


    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _lb_msg: Laya.HTMLDivElement
    _Image9: Laya.Image
    _Label1: Laya.Label
    _btn_cancal: Laya.Box
    _Image111: Laya.Image
    labelDisplay: Laya.Label
    _btn_ok: Laya.Box
    _Image11: Laya.Image
    labelDisplay1: Laya.Label
    _Group1: Laya.HBox
    _group_left: Laya.Box
    _Image4: Laya.Image
    _img_lvip: Laya.Image
    _lb_lcount: Laya.HTMLDivElement
    _Image5: Laya.Image
    _img_arrow: Laya.Image
    _group_right: Laya.Box
    _Image6: Laya.Image
    _img_rvip: Laya.Image
    _lb_rcount: Laya.HTMLDivElement
    _Group2: Laya.Box
    _Image7: Laya.Image
    _Label2: Laya.Label
    _Image8: Laya.Image
    _btn_close: Laya.Image
    _Image10: Laya.Image


    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Image3,
            this._lb_msg,
            this._Image9,
            this._Label1,
            this._btn_cancal,
            this._Image111,
            this.labelDisplay,
            this._btn_ok,
            this._Image11,
            this.labelDisplay1,
            this._Group1,
            this._group_left,
            this._Image4,
            this._img_lvip,
            this._lb_lcount,
            this._Image5,
            this._img_arrow,
            this._group_right,
            this._Image6,
            this._img_rvip,
            this._lb_rcount,
            this._Group2,
            this._Image7,
            this._Label2,
            this._Image8,
            this._btn_close,
            this._Image10
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Image3",
                "_lb_msg",
                "_Image9",
                "_Label1",
                "_btn_cancal",
                "_Image111",
                "labelDisplay",
                "_btn_ok",
                "_Image11",
                "labelDisplay1",
                "_Group1",
                "_group_left",
                "_Image4",
                "_img_lvip",
                "_lb_lcount",
                "_Image5",
                "_img_arrow",
                "_group_right",
                "_Image6",
                "_img_rvip",
                "_lb_rcount",
                "_Group2",
                "_Image7",
                "_Label2",
                "_Image8",
                "_btn_close",
                "_Image10"
            ])
        this._lb_msg.style.fontSize = 20;
        this._lb_msg.style.color = "#663915";
        this._lb_msg.style.wordWrap = false;
        this._lb_lcount.style.fontSize = 18;
        this._lb_lcount.style.color = "#5e6382";
        this._lb_lcount.style.wordWrap = false;
        this._lb_rcount.style.fontSize = 18;
        this._lb_rcount.style.color = "#5e6382";
        this._lb_rcount.style.wordWrap = false;
        this.labelDisplay1.text = '前往提升';
        this._lb_msg.x = 193;
    }
}
window["SpecialPackageBuyTimesView"] = SpecialPackageBuyTimesView
