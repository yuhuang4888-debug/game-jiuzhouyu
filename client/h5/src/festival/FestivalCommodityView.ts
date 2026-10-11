import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { EnumFestivalProtocol } from '../commonController/FestivalController';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { EnumFestivalGetRewardType, EnumFestivalType, EnumFestivalTypeName, FestivalModel, FestivalModelEvent, IS2CFestivalBasicInfo } from '../commonModel/FestivalModel';
import { RoleManager } from '../commonModel/RoleManager';
import { PlatformManager } from '../PlatformManager';
import { MainRoleVo } from '../sharedata/MainRoleVo';
import { GameResPath } from '../util/GameResPath';
import { SYTweenFunc } from '../util/SYTweenFunc';
import { SYTweenLite } from '../util/SYTweenLite';
import { NotEnougnDiamond, Trim, Util } from '../util/Util';
import { FestivalInfoListItem } from './FestivalInfoListItem';
import { BaseItem1 } from './../common/BaseItem1';
import { Alert, Alert_Type } from '../alert/Alert';
import { ErlangParser } from './../util/ErlangParser';
import { FestivalRewardItem } from './FestivalRewardItem';
import { FestivalGetRewardView } from './FestivalGetRewardView';
import { UIToolTipMgr } from '../common/UIToolTipMgr';
import { GoodsModel } from '../commonModel/GoodsModel';
import { VipModel } from '../commonModel/VipModel';


export class FestivalCommodityView extends BaseItem1 {
    static _layout_file: string = 'FestivalCommodityView';
    private conf: any;
    private confRechargeProduct: any;
    private tween_id1: number;
    private tween_id2: number;
    private loop_mgr1: LoopScrowViewMgr;
    private loop_mgr2: LoopScrowViewMgr;
    private loop_mgr3: LoopScrowViewMgr;

    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor(parent?: any) {
        super(parent);

        this.base_file = 'festival';
        this.layout_file = 'FestivalCommodityView';
        this.layer_value = Enum_UILayer.Activity;

        this.preload_client_config = {
            ClientConfigFiestaIntroduce: false,
        };

        this.preload_server_config = {
            config_recharge_product: false
        }

        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };

    }

    private LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.title1Img,
            GameResPath.GetIcon('festival', 'ui_msz_hhjd01')
        );
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.title2Img,
            GameResPath.GetIcon('festival', 'ui_db_jd03')
        );
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bg1Img,
            GameResPath.GetIcon('festival', 'ui_db_jd03-2')
        );
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.bg2Img,
            GameResPath.GetIcon('festival', 'ui_db_jd04')
        );

        let cfg = ResManager.GetInstance().GetGameConfigFromCache(
            this,
            'ClientConfigFiestaIntroduce',
            true
        );
        let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(
            this,
            'config_recharge_product',
            false
        );
        if (!(cfg && cfg1)) return;

        this.conf = cfg;
        this.confRechargeProduct = cfg1;
        this.SetIcon(this.icon1Img, this.icon1Box, this.effect1Box, EnumFestivalTypeName.eLuxury);
        this.SetIcon(this.icon2Img, this.icon2Box, this.effect2Box, EnumFestivalTypeName.eSupreme);
        this.SetAwards(this.desc1List, EnumFestivalTypeName.eLuxury);
        this.SetAwards(this.desc2List, EnumFestivalTypeName.eSupreme);
        this.RenderBtn();
        this.RenderDesc(EnumFestivalTypeName.eLuxury);
        this.RenderDesc(EnumFestivalTypeName.eSupreme);
        this.RednerIconList(EnumFestivalTypeName.eSupreme);
    }



    public InitEvent() {
        // 点击购买
        Util.AddClickEvent(
            this.buy1Btn,
            () => {
                if (this.EnoughToken(EnumFestivalTypeName.eLuxury)) {
                    this.UseToken(EnumFestivalTypeName.eLuxury)
                } else {
                    this.FestivalModel.Fire(
                        FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                        FestivalGetRewardView._layout_file,
                        { type: EnumFestivalGetRewardType.eBuy, rewars1: this.FestivalModel.GetAllPremiumReward(), rewars2: this.FestivalModel.GetFestivalOrderRewards(EnumFestivalTypeName.eLuxury), festivalType: EnumFestivalType.eLuxury, festivalTypeName: EnumFestivalTypeName.eLuxury }
                    );
                }

            },
            this,
            true
        );
        // 点击购买
        Util.AddClickEvent(
            this.buy2Btn,
            () => {
                if (this.EnoughToken(EnumFestivalTypeName.eSupreme)) {
                    this.UseToken(EnumFestivalTypeName.eSupreme)
                } else {
                    this.FestivalModel.Fire(
                        FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                        FestivalGetRewardView._layout_file,
                        { type: EnumFestivalGetRewardType.eBuy, rewars1: this.FestivalModel.GetAllPremiumReward(), rewars2: this.FestivalModel.GetFestivalOrderRewards(EnumFestivalTypeName.eSupreme), festivalType: EnumFestivalType.eSupreme, festivalTypeName: EnumFestivalTypeName.eSupreme }
                    );
                }

            },
            this,
            true
        );


        Util.AddClickEvent(
            this.icon1Box,
            () => {
                this.ItemTips(EnumFestivalTypeName.eLuxury)
            },
            this,
            true
        );

        Util.AddClickEvent(
            this.icon2Box,
            () => {
                this.ItemTips(EnumFestivalTypeName.eSupreme)
            },
            this,
            true
        );

        Util.AddClickEvent(
            this.icon1Img,
            () => {
                this.ItemTips(EnumFestivalTypeName.eLuxury)
            },
            this,
            true
        );

        Util.AddClickEvent(
            this.icon2Img,
            () => {
                this.ItemTips(EnumFestivalTypeName.eSupreme)
            },
            this,
            true
        );


        this.BindEvent(this.FestivalModel, FestivalModelEvent.FESTIVAL_BASIC_INIT, () => {
            this.RenderBtn();
        });

    }

    /**
     * 渲染icon
     */
    private SetIcon(iconImg: Laya.Image, iconBox: Laya.Box, effectBox: Laya.Box, type: EnumFestivalTypeName) {
        let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        // 默认拿id为6的,因为6的为这个弹窗的信息
        let confChild = this.conf[cmd.act_id.toString()][type];

        // 根据类型现在不同的icon
        switch (confChild.icon_type) {
            case '1': // 图片
                iconImg.visible = true;
                iconBox.visible = false;
                effectBox.visible = false;
                ResManager.GetInstance().SetOutsideImageSprite(
                    this,
                    iconImg,
                    GameResPath.GetIcon('festival', Trim(confChild.resource_id)),
                    true
                );
                this.ImgModelAnimation(iconImg, type);
                break;
            case '2': // 模型
                iconImg.visible = false;
                iconBox.visible = true;
                effectBox.visible = false;
                this.ShowModel(iconBox, confChild.resource_id);
                break;
            case '3': // 特效
                iconImg.visible = false;
                iconBox.visible = false;
                effectBox.visible = true;
                effectBox.width = Laya.stage.width;
                effectBox.height = Laya.stage.height;
                this.AddUIEffect(
                    Trim(confChild.resource_id),
                    effectBox,
                    null,
                    null,
                    true
                );
                break;
            default:
                break;
        }
    }

    /**
     * 渲染奖励
     */
    private SetAwards(descList: Laya.List, type: EnumFestivalTypeName) {
        let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confChild = this.conf[cmd.act_id.toString()][type];
        let list: { item_id: string, desc: string }[] = confChild.award;
        if (type == EnumFestivalTypeName.eLuxury) {
            if (!this.loop_mgr1) {
                this.loop_mgr1 = new LoopScrowViewMgr();
                this.loop_mgr1.SetData(
                    descList,
                    FestivalInfoListItem,
                    list,
                    LoopScrCon.Vertical
                );
            } else {
                this.loop_mgr1.replaceAll(list);
            }
        } else {
            if (!this.loop_mgr2) {
                this.loop_mgr2 = new LoopScrowViewMgr();
                this.loop_mgr2.SetData(
                    descList,
                    FestivalInfoListItem,
                    list,
                    LoopScrCon.Vertical
                );
            } else {
                this.loop_mgr2.replaceAll(list);
            }
        }
    }

    private RednerIconList(type: EnumFestivalTypeName) {
        let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confChild = this.conf[cmd.act_id.toString()][type];
        let rewars: any[] = ErlangParser.GetInstance().parse(confChild['rewards']);
        if (!this.loop_mgr3) {
            this.loop_mgr3 = new LoopScrowViewMgr();
            this.loop_mgr3.SetData(
                this.iconList,
                FestivalRewardItem,
                rewars,
                LoopScrCon.Vertical
            );
        } else {
            this.loop_mgr3.replaceAll(rewars);
        }
    }


    /**
     * 渲染描述
     * @param type 
     */
    private RenderDesc(type: EnumFestivalTypeName) {
        let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confChild = this.conf[cmd.act_id.toString()][type];
        let descs: string[] = confChild.desc;

        if (type == EnumFestivalTypeName.eLuxury) {
            this.descHtml1.style.fontSize = this.descHtml2.style.fontSize = 26;
            this.descHtml1.style.color = this.descHtml2.style.color = '#0D1040';
            this.descHtml1.style.stroke = this.descHtml2.style.stroke = 2;
            this.descHtml1.style.strokeColor = this.descHtml2.style.strokeColor = '#FFFFFF';
            this.descHtml1.style.width = this.descHtml2.style.width = 28;
            this.descHtml1.style.height = this.descHtml2.style.height = 220;
            this.descHtml1.style.wordWrap = this.descHtml2.style.wordWrap = true;
            this.descHtml1.style.bold = this.descHtml2.style.bold = true;
            this.descHtml1.style.leading = this.descHtml2.style.leading = 2;
            this.descHtml1.innerHTML = descs[0];
            this.descHtml2.innerHTML = descs[1];
        } else {
            this.descHtml3.style.fontSize = this.descHtml4.style.fontSize = this.descHtml5.style.fontSize = 26;
            this.descHtml3.style.color = this.descHtml4.style.color = this.descHtml5.style.color = '#EA5521';
            this.descHtml3.style.stroke = this.descHtml4.style.stroke = this.descHtml5.style.stroke = 2;
            this.descHtml3.style.strokeColor = this.descHtml4.style.strokeColor = this.descHtml5.style.strokeColor = '#FFFFFF';
            this.descHtml3.style.width = this.descHtml4.style.width = this.descHtml5.style.width = 28;
            this.descHtml3.style.height = this.descHtml4.style.height = this.descHtml5.style.height = 220;
            this.descHtml3.style.wordWrap = this.descHtml4.style.wordWrap = this.descHtml5.style.wordWrap = true;
            this.descHtml3.style.bold = this.descHtml4.style.bold = this.descHtml5.style.bold = true;
            this.descHtml3.style.leading = this.descHtml4.style.leading = this.descHtml5.style.leading = 2;

            this.descHtml3.innerHTML = descs[0];
            this.descHtml4.innerHTML = descs[1];
            this.descHtml5.innerHTML = descs[2];
        }

    }

    /**
     * 渲染按钮
     */
    private RenderBtn() {
        let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        if (this.FestivalModel.GetFestivalIsBuy()) {

            if (info.type == EnumFestivalType.eLuxury) {
                this.buy1Btn.visible = false;
                this.get1Img.visible = true;

                this.buy2Btn.visible = false;
                this.get2Img.visible = false;
            } else {
                this.buy1Btn.visible = false;
                this.get1Img.visible = false;

                this.buy2Btn.visible = false;
                this.get2Img.visible = true;
            }

        } else {

            this.buy2Btn.visible = true;
            this.buy1Btn.visible = true;

            this.get1Img.visible = false;
            this.get2Img.visible = false;

            // 判断是否为直购
            this.cost1Lab.visible = this.FestivalModel.GetTypeFestivalDirectPurchase(EnumFestivalTypeName.eLuxury);
            this.cost1Img.visible = !this.FestivalModel.GetTypeFestivalDirectPurchase(EnumFestivalTypeName.eLuxury);
            this.cost2Lab.visible = this.FestivalModel.GetTypeFestivalDirectPurchase(EnumFestivalTypeName.eSupreme);
            this.cost2Img.visible = !this.FestivalModel.GetTypeFestivalDirectPurchase(EnumFestivalTypeName.eSupreme);

            this.RenderText(EnumFestivalTypeName.eLuxury, this.num1Lab, this.buy1Lab);
            this.RenderText(EnumFestivalTypeName.eSupreme, this.num2Lab, this.buy2Lab);

        }

    }

    /**
     * 弹出道具详情
     */
    private ItemTips(type: EnumFestivalTypeName) {
        let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
        let confChild = this.conf[cmd.act_id.toString()][type];
        let goods = GoodsModel.GetInstance().GetGoodsBasicByTypeId(confChild.item_id);
        if (confChild.icon_type == 1) {
            UIToolTipMgr.GetInstance().AppendGoodsTips(confChild.item_id, null, null, goods)
        } else {
            UIToolTipMgr.GetInstance().AppendIllusionTips(confChild.item_id, null, null, goods)
        }
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

    /**
     * 代币是否足够
     */
    private EnoughToken(typeName: EnumFestivalTypeName) {
        let cost: any[] = this.FestivalModel.GetTypeFestivalTypeConf(typeName);
        let conf: any = this.confRechargeProduct[cost[0][1]];
        let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具

        return hasNum >= conf.money && this.FestivalModel.GetTypeFestivalDirectPurchase(typeName);

    }


    /**
     * 使用代币
     */
    private UseToken(typeName: EnumFestivalTypeName) {
        let cost: any[] = this.FestivalModel.GetTypeFestivalTypeConf(typeName);
        let conf: any = this.confRechargeProduct[cost[0][1]];
        VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', conf.product_id)
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


    private ShowModel(iconBox: Laya.Box, model_id: string) {
        model_id = JSON.parse(model_id);
        CustomActivityModel.GetInstance().ShowViewModel(
            this,
            this.layout_file,
            model_id,
            iconBox,
            null,
            null,
            null,
            null,
            false,
            true
        );
    }

    private ImgModelAnimation(iconImg: Laya.Image, type: EnumFestivalTypeName) {
        if (type == EnumFestivalTypeName.eLuxury) {
            if (!this.tween_id1) {
                this.tween_id1 = SYTweenLite.to(
                    this,
                    iconImg,
                    SYTweenLite.UiAnimationType.POSY,
                    iconImg.y - 30,
                    2.2,
                    null,
                    SYTweenFunc.PINGPONG,
                    true
                );
            }
        } else {
            if (!this.tween_id2) {
                this.tween_id2 = SYTweenLite.to(
                    this,
                    iconImg,
                    SYTweenLite.UiAnimationType.POSY,
                    iconImg.y - 30,
                    2.2,
                    null,
                    SYTweenFunc.PINGPONG,
                    true
                );
            }
        }

    }


    private LocalDeleteMe() {
        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }
        if (this.loop_mgr2) {
            this.loop_mgr2.DeleteMe();
            this.loop_mgr2 = null;
        }
        if (this.loop_mgr3) {
            this.loop_mgr3.DeleteMe();
            this.loop_mgr3 = null;
        }
        if (this.tween_id1) {
            this.tween_id1 = null;
        }
        if (this.tween_id2) {
            this.tween_id2 = null;
        }
        super.DeleteMe();
    }

    public DeleteMe() {
        this.LocalDeleteMe();

    }



    title1Img: Laya.Image
    bg1Img: Laya.Image
    title2Img: Laya.Image
    bg2Img: Laya.Image
    desc1List: Laya.List
    desc2List: Laya.List
    iconList: Laya.List
    icon1Box: Laya.Box
    icon2Box: Laya.Box
    effect1Box: Laya.Box
    effect2Box: Laya.Box
    icon1Img: Laya.Image
    icon2Img: Laya.Image
    descHtml1: Laya.HTMLDivElement
    descHtml2: Laya.HTMLDivElement
    descHtml3: Laya.HTMLDivElement
    descHtml4: Laya.HTMLDivElement
    descHtml5: Laya.HTMLDivElement
    buy1Btn: Laya.Box
    cost1Img: Laya.Image
    buy1Lab: Laya.Label
    cost1Lab: Laya.Label
    num1Lab: Laya.Label
    buy2Btn: Laya.Box
    cost2Img: Laya.Image
    buy2Lab: Laya.Label
    cost2Lab: Laya.Label
    num2Lab: Laya.Label
    get1Img: Laya.Image
    get2Img: Laya.Image
    public GetComponents() {
        [
            this.title1Img,
            this.bg1Img,
            this.title2Img,
            this.bg2Img,
            this.desc1List,
            this.desc2List,
            this.iconList,
            this.icon1Box,
            this.icon2Box,
            this.effect1Box,
            this.effect2Box,
            this.icon1Img,
            this.icon2Img,
            this.descHtml1,
            this.descHtml2,
            this.descHtml3,
            this.descHtml4,
            this.descHtml5,
            this.buy1Btn,
            this.cost1Img,
            this.buy1Lab,
            this.cost1Lab,
            this.num1Lab,
            this.buy2Btn,
            this.cost2Img,
            this.buy2Lab,
            this.cost2Lab,
            this.num2Lab,
            this.get1Img,
            this.get2Img,
        ]
            = this.GetChildrenByNames([

                "title1Img",
                "bg1Img",
                "title2Img",
                "bg2Img",
                "desc1List",
                "desc2List",
                "iconList",
                "icon1Box",
                "icon2Box",
                "effect1Box",
                "effect2Box",
                "icon1Img",
                "icon2Img",
                "descHtml1",
                "descHtml2",
                "descHtml3",
                "descHtml4",
                "descHtml5",
                "buy1Btn",
                "cost1Img",
                "buy1Lab",
                "cost1Lab",
                "num1Lab",
                "buy2Btn",
                "cost2Img",
                "buy2Lab",
                "cost2Lab",
                "num2Lab",
                "get1Img",
                "get2Img",
            ])
    }
}
window["FestivalCommodityView"] = FestivalCommodityView