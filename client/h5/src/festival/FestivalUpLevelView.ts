import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { FestivalModel, FestivalModelEvent, IS2CFestivalBasicInfo } from '../commonModel/FestivalModel';
import { RoleManager } from '../commonModel/RoleManager';
import { ShopEvent, ShopModel } from '../commonModel/ShopModel';
import { MainRoleVo } from '../sharedata/MainRoleVo';
import { NotEnougnDiamond, Util } from '../util/Util';

export class FestivalUpLevelView extends BaseView1 {

    private conf: any;
    private costNum: number = 1;
    private readonly goosId: number = 37120001; // 拿这个商品id做经验换算;


    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'festival';
        this.layout_file = 'FestivalUpLevelView';
        this.use_background = true
        this.is_center = true
        this.click_bg_toClose = true;
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true

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
                if (this.FestivalModel.loginTips) {
                    this.BuyGoods();
                } else {
                    let num: number = Math.ceil(this.barHSlider.value / 100 * this.costNum)
                    this.FestivalModel.Fire(
                        FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                        'FestivalUpLevelTipsView', num
                    );
                }



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

        // 预加载资源 不然图标会位置会显示不对
        let skins: Array<string> = [];
        skins.push("resource/game/festival/texture/set_11$bar.png");
        // Laya.loader.load(skins, Laya.Handler.create(this, this.));
        this.RenderViwe();
    }


    private RenderViwe() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        // 所需要的印花数量
        this.costNum = this.FestivalModel.GetFetivalCurLvToNextLvCostExpNum();

        this.curLvLab.text = `Lv.${info.lv}`;
        this.nextLvLab.text = `Lv.${info.lv + 1}`;
        this.numLab.text = `${this.costNum}`;
        // this.barHSlider.width = 304;
        this.barHSlider.changeHandler = new Laya.Handler(this, this.ChangeBarHSlider);
        this.barHSlider.bar.stateNum = 1;
        this.barHSlider.bar.zOrder = 2;
        this.barHSlider.value = 100;
        // this.ChangeBarHSlider(this.barHSlider.value);
    }

    private ChangeBarHSlider(value: number) {
        // this.barHSlider.bar.stateNum = 1;
        this.barHSlider.bar.y = 0;
        this.barImg.width = value / 100 * 300;
        this.hasNumLab.changeText(`${Math.ceil(value / 100 * this.costNum)}`);
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



    cancelBtn: Laya.Box
    buyBtn: Laya.Box
    closeBtn: Laya.Box
    close: Laya.Image
    hasNumLab: Laya.Label
    numLab: Laya.Label
    curLvLab: Laya.Label
    nextLvLab: Laya.Label
    costLab: Laya.Label
    barHSlider: Laya.HSlider
    barImg: Laya.Image
    public GetComponents() {
        [
            this.cancelBtn,
            this.buyBtn,
            this.closeBtn,
            this.close,
            this.hasNumLab,
            this.numLab,
            this.curLvLab,
            this.nextLvLab,
            this.costLab,
            this.barHSlider,
            this.barImg,
        ]
            = this.GetChildrenByNames([

                "cancelBtn",
                "buyBtn",
                "closeBtn",
                "close",
                "hasNumLab",
                "numLab",
                "curLvLab",
                "nextLvLab",
                "costLab",
                "barHSlider",
                "barImg",
            ])
    }
}
window["FestivalUpLevelView"] = FestivalUpLevelView