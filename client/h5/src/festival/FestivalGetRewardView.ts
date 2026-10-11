import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { EnumFestivalGetRewardType, EnumFestivalType, EnumFestivalTypeName, FestivalModel, FestivalModelEvent, IFestivalGetRewardParam, IS2CFestivalBasicInfo } from '../commonModel/FestivalModel';
import { NotEnougnDiamond, SetSizeDeltaY, Util } from '../util/Util';
import { FestivalRewardItem } from './FestivalRewardItem';
import { FestivalBaseView } from './FestivalBaseView';
import { ResManager } from '../common/ResManager';
import { GameResPath } from '../util/GameResPath';
import { PlatformManager } from '../PlatformManager';
import { EnumFestivalProtocol } from '../commonController/FestivalController';
import { RoleManager } from '../commonModel/RoleManager';
import { MainRoleVo } from '../sharedata/MainRoleVo';
import { Alert, Alert_Type } from '../alert/Alert';
import { GoodsModel } from '../commonModel/GoodsModel';


export class FestivalGetRewardView extends BaseView1 {
    static _layout_file: string = 'FestivalGetRewardView';
    private _param: IFestivalGetRewardParam;

    private loop_mgr: LoopScrowViewMgr;
    private loop_mgr1: LoopScrowViewMgr;
    private confRechargeProduct: any;

    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'festival';
        this.layout_file = 'FestivalGetRewardView';
        this.use_background = true
        this.is_center = true
        this.click_bg_toClose = true;
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true

        this.open_callback = () => {
            this.loop_mgr = null;
            this.loop_mgr1 = null;
        }

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.preload_server_config = {
            config_recharge_product: false
        }


    }

    public InitEvent() {
        // 点击购买/跳转
        Util.AddClickEvent(
            this.jumpBox,
            () => {
                if (this._param.type == EnumFestivalGetRewardType.eNotBuy) {
                    this.FestivalModel.Fire(
                        FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                        FestivalBaseView._layout_file,
                        2
                    );
                    this.Close();
                } else {
                    this.ClickBuy(this._param.festivalTypeName, this._param.festivalType);
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

        this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_BASIC_INIT, () => {
            this.Close();
        });

    }

    private LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bgImg,
            GameResPath.GetIconOtherPath('festival', 'ui_db_jd022')
        );

        let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(
            this,
            'config_recharge_product',
            false
        );
        if (!cfg1) return;
        this.confRechargeProduct = cfg1;
        this.RenderView();
    }



    private RenderView() {
        this.notList.visible = this._param.type != EnumFestivalGetRewardType.eBought;
        this.jumpBox.visible = this._param.type != EnumFestivalGetRewardType.eBought;
        this.bgImg1.visible = this._param.type != EnumFestivalGetRewardType.eBought;
        this.descLab1.visible = this._param.type != EnumFestivalGetRewardType.eBought;
        SetSizeDeltaY(this.bgImg2, this._param.type != EnumFestivalGetRewardType.eBought ? 211 : 498)
        SetSizeDeltaY(this.getList, this._param.type != EnumFestivalGetRewardType.eBought ? 200 : 490)

        let titleSrc: string = this._param.festivalType == EnumFestivalType.eLuxury ? '豪华祭典' : '至尊祭典';
        this.titleLab.changeText(this._param.type == EnumFestivalGetRewardType.eBuy ? titleSrc : '领取成功');
        this.descLab2.changeText(this._param.type == EnumFestivalGetRewardType.eBuy ? `购买${titleSrc}后可解锁以下奖励` : '当前领取的全部奖励');
        this.descLab1.changeText(this._param.type == EnumFestivalGetRewardType.eBuy ? '现在购买可立即领取' : '进阶祭典可以再领取以下奖励');

        switch (this._param.type) {
            case EnumFestivalGetRewardType.eNotBuy:
                this.cost1Lab.visible = false;
                this.cost1Img.visible = false;
                this.descLab.visible = true;
                this.RenderReward1();
                this.RenderReward2();
                this.descLab.changeText(`前往进阶`);
                break;
            case EnumFestivalGetRewardType.eBought:
                this.cost1Lab.visible = false;
                this.cost1Img.visible = false;
                this.RenderReward1();
                break;
            case EnumFestivalGetRewardType.eBuy:
                this.descLab.visible = false;
                this.RenderReward1();
                this.RenderReward2();
                this.RenderBtn();
                break;

            default:
                break;
        }
    }

    /**
  * 渲染按钮
  */
    private RenderBtn() {
        // 判断是否为直购
        this.cost1Lab.visible = this.FestivalModel.GetTypeFestivalDirectPurchase(this._param.festivalTypeName);
        this.cost1Img.visible = !this.FestivalModel.GetTypeFestivalDirectPurchase(this._param.festivalTypeName);
        this.RenderText(this._param.festivalTypeName, this.num1Lab, this.buy1Lab);

    }

    /**
     * 渲染按钮文字
     * @param type 
     * @param numLab 
     * @param buyLab 
     */
    private RenderText(type: EnumFestivalTypeName, numLab: Laya.Label, buyLab: Laya.Label) {
        let cost: any[] = this.FestivalModel.GetTypeFestivalTypeConf(type);
        if (this.FestivalModel.GetTypeFestivalDirectPurchase(type)) {
            let conf: any = this.confRechargeProduct[cost[0][1]];
            numLab.changeText(`${conf.money}`);
        } else {
            buyLab.changeText(`${cost[0][2]}`);
        }
    }


    private RenderReward1() {

        this._param.rewars1.sort((a: any, b: any) => {
            let basicA = GoodsModel.GetInstance().GetGoodsBasicByTypeId(a[1])
            let basicB = GoodsModel.GetInstance().GetGoodsBasicByTypeId(b[1])
            return basicB.color - basicA.color;
        });

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.getList,
                FestivalRewardItem,
                this._param.rewars1,
                LoopScrCon.Vertical
            );
        } else {
            this.loop_mgr.replaceAll(this._param.rewars1);
        }
    }

    private RenderReward2() {

        this._param.rewars2.sort((a: any, b: any) => {
            let basicA = GoodsModel.GetInstance().GetGoodsBasicByTypeId(a[1])
            let basicB = GoodsModel.GetInstance().GetGoodsBasicByTypeId(b[1])
            return basicB.color - basicA.color;
        });

        if (!this.loop_mgr1) {
            this.loop_mgr1 = new LoopScrowViewMgr();
            this.loop_mgr1.SetData(
                this.notList,
                FestivalRewardItem,
                this._param.rewars2,
                LoopScrCon.Vertical
            );
        } else {
            this.loop_mgr1.replaceAll(this._param.rewars2);
        }
    }

    /**
    * 点击购买
    */
    private ClickBuy(typeName: EnumFestivalTypeName, type: EnumFestivalType) {
        let costData: any[] = this.FestivalModel.GetTypeFestivalTypeConf(typeName);
        if (this.FestivalModel.GetTypeFestivalDirectPurchase(typeName)) {
            let cost: number = costData[0][1];
            let conf: any = this.confRechargeProduct[cost.toString()];
            this.Pay(conf.money, conf.product_id, conf.product_name);
        } else {
            let mainVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
            let cost: number = costData[0][2];
            let strName: string = type == EnumFestivalType.eLuxury ? '豪华庆典' : '至尊庆典';
            if (mainVo.jin >= cost) {
                Alert.Show(`是否消耗${cost}勾玉激活${strName}`, Alert_Type.Two, () => {
                    this.BuyFestival(type)
                }, null, "确定", '取消');
            } else {
                NotEnougnDiamond();
            }
        }
    }

    /**
    * 调充值
    * @param money 充值金额 
    * @param id 
    * @param title 
    */
    private Pay(money: number, id: number, title: string) {
        PlatformManager.GetInstance().PayRequest(money, { id: id, pay_title: title });
    }

    /**
     * 购买高级庆典
     */
    private BuyFestival(type: number) {
        this.FestivalModel.Fire(
            FestivalModelEvent.FESTIVAL_REQUEST_PROTO,
            EnumFestivalProtocol.eProtocol19405, 'c', type
        );
    }

    public Open(...new_args) {
        this._param = new_args[0];
        super.Open();
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
        super.DeleteMe()
    }



    bgImg: Laya.Image
    descLab1: Laya.Label
    bgImg2: Laya.Image
    getList: Laya.List
    bgImg1: Laya.Image
    notList: Laya.List
    jumpBox: Laya.Box
    descLab: Laya.Label
    cost1Img: Laya.Image
    buy1Lab: Laya.Label
    cost1Lab: Laya.Label
    num1Lab: Laya.Label
    descLab2: Laya.Label
    titleLab: Laya.Label
    closeBtn: Laya.Box
    public GetComponents() {
        [
            this.bgImg,
            this.descLab1,
            this.bgImg2,
            this.getList,
            this.bgImg1,
            this.notList,
            this.jumpBox,
            this.descLab,
            this.cost1Img,
            this.buy1Lab,
            this.cost1Lab,
            this.num1Lab,
            this.descLab2,
            this.titleLab,
            this.closeBtn,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "descLab1",
                "bgImg2",
                "getList",
                "bgImg1",
                "notList",
                "jumpBox",
                "descLab",
                "cost1Img",
                "buy1Lab",
                "cost1Lab",
                "num1Lab",
                "descLab2",
                "titleLab",
                "closeBtn",
            ])
    }
}
window["FestivalGetRewardView"] = FestivalGetRewardView