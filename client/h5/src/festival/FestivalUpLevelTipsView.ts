import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { FestivalModel, IS2CFestivalBasicInfo } from '../commonModel/FestivalModel';
import { RoleManager } from '../commonModel/RoleManager';
import { ShopEvent, ShopModel } from '../commonModel/ShopModel';
import { MainRoleVo } from '../sharedata/MainRoleVo';
import { NotEnougnDiamond, Util } from '../util/Util';

export class FestivalUpLevelTipsView extends BaseView1 {
    static _layout_file: string = "FestivalUpLevelTipsView";

    private conf: any;
    private costNum: number = 1;
    private readonly goosId: number = 37120001; // 拿这个商品id做经验换算;


    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'festival';
        this.layout_file = 'FestivalUpLevelTipsView';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;

        this.preload_server_config = {
            config_quick_buy_price: false
        }

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

    }



    public InitEvent() {
        // 点击购买
        Util.AddClickEvent(
            this.buyBtn,
            () => {
                this.BuyGoods();
            },
            this,
            true
        );
        // 点击取消
        Util.AddClickEvent(
            this.closeBtn,
            () => {
                this.Close();
            },
            this,
            true
        );
        // 点击取消
        Util.AddClickEvent(
            this.cancelBtn,
            () => {
                this.Close();
            },
            this,
            true
        );

        // 点击选择是否提示
        Util.AddClickEvent(
            this.selectBox,
            () => {
                this.FestivalModel.loginTips = !this.FestivalModel.loginTips;
                this.select1Img.visible = !this.FestivalModel.loginTips;
                this.select2Img.visible = this.FestivalModel.loginTips;
            },
            this,
            true
        );

        this.BindEvent(ShopModel.GetInstance(), ShopEvent.BUY_GOODS_SUCCESS, () => {
            this.Close();
        });

    }


    private LoadSuccess() {
        let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_quick_buy_price", false);

        if (!cfgs) {
            return;
        }

        this.conf = cfgs;
        this.RenderViwe();
    }


    private RenderViwe() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let goldPrice: number = this.conf[this.goosId.toString()]['gold_price'];
        this.costNum1Lab.changeText(`${this.costNum * goldPrice}`);
        this.costNum2Lab.changeText(`${this.costNum}`);
        this.levelLab.changeText(`${info.lv + 1}`);
    }

    /**
     * 点击购买
     */
    private BuyGoods() {
        let goldPrice: number = this.conf[this.goosId.toString()]['gold_price'];
        let mainVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
        let sumCost: number = this.costNum * goldPrice;

        if (mainVo.jin >= sumCost) {
            ShopModel.GetInstance().Fire(ShopEvent.SHOP_REQUEST_PROTO, 15304, "iic", this.goosId, this.costNum, 1);
        } else {
            NotEnougnDiamond();
        }

    }


    public Open(...new_args) {
        this._Local_Open(new_args)
    }

    private _Local_Open(parms: any) {
        this.costNum = parms[0];
        super.Open();
    }





    costNum1Lab: Laya.Label
    costNum2Lab: Laya.Label
    levelLab: Laya.Label
    closeBtn: Laya.Box
    cancelBtn: Laya.Box
    buyBtn: Laya.Box
    selectBox: Laya.Box
    select1Img: Laya.Image
    select2Img: Laya.Image
    public GetComponents() {
        [
            this.costNum1Lab,
            this.costNum2Lab,
            this.levelLab,
            this.closeBtn,
            this.cancelBtn,
            this.buyBtn,
            this.selectBox,
            this.select1Img,
            this.select2Img,
        ]
            = this.GetChildrenByNames([

                "costNum1Lab",
                "costNum2Lab",
                "levelLab",
                "closeBtn",
                "cancelBtn",
                "buyBtn",
                "selectBox",
                "select1Img",
                "select2Img",
            ])
    }
}
window["FestivalUpLevelTipsView"] = FestivalUpLevelTipsView