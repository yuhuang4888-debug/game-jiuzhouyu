import { BaseView1 } from '../common/BaseView1';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { ActivityIconManager } from '../commonModel/ActivityIconManager';
import { CustomActivityDefine } from '../commonModel/CustomActivityDefine';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { OneDollarSpikeModel, OneDollarSpikeModelEvent } from '../commonModel/OneDollarSpikeModel';
import { VipModel } from '../commonModel/VipModel';
import { PlatformManager } from '../PlatformManager';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { ErlangParser } from '../util/ErlangParser';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { OneDollarSpikeAwardItem } from './OneDollarSpikeAwardItem';
import { OneDollarSpikeTabItem } from './OneDollarSpikeTabItem';

export class OneDollarSpikeView extends BaseView1 {
    static _layout_file: string = "OneDollarSpikeView";

    public SetActInfo: Function;
    private loop_mgr: LoopScrowViewMgr;
    private loop_mgr1: LoopScrowViewMgr;
    private actInfo: any;
    private actDate: any;
    private rechargeConf: any;

    /**默认选中最会一个页签 */
    private defTabIndex: number = 2;

    private get OneDollarSpikeModel() {
        return OneDollarSpikeModel.GetInstance();
    }

    public constructor() {
        super();

        this.base_file = 'oneDollarSpike';
        this.layout_file = 'OneDollarSpikeView';
        this.use_background = true;
        this.click_bg_toClose = true;
        this.is_center = true;
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;

        this.preload_server_config = {
            config_recharge_product: false
        }

        this.load_callback = () => {
            this.InitEvent();
            this.LoadSuccess();
        };

        this.close_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
            if (this.loop_mgr1) {
                this.loop_mgr1.DeleteMe();
                this.loop_mgr1 = null;
            }
            this.DeleteActIcon();
        }

        this.SetActInfo = (info: any, parm: any) => {
            if (!info) return
            this.actInfo = info;
            this.GetActDate();
        }

    }

    public LoadSuccess() {

        ResManager.GetInstance().SetTexture(
            this,
            this.bgImg,
            GameResPath.GetIconOtherPath('oneDollarSpike', 'ui_mrzg_bg_01')
        );
        ResManager.GetInstance().SetTexture(
            this,
            this.titleImg1,
            GameResPath.GetIconOtherPath('oneDollarSpike', 'ui_mrzg_05')
        );
        this.AddUIEffect("ui_anniu_6", this.effectBox, { x: 0, y: 0 }, 10, true);
        let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(
            this,
            'config_recharge_product',
            false
        );
        if (!cfg1) return;

        this.rechargeConf = cfg1;
        this.RenderView();
    }

    public InitEvent() {
        // 点击购买单个礼包
        Util.AddClickEvent(
            this.spikeBox,
            () => {
                let infoDate = this.actDate.reward_list[this.defTabIndex];
                let rechargeId: number = ErlangParser.GetInstance().parse(infoDate.condition)[0][1];
                let conf: any = this.rechargeConf[rechargeId];
                let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                if (hasNum >= conf.money) {
                    this.UseToken();
                } else {
                    this.Pay(conf.money, conf.product_id, conf.product_name);
                }
            },
            this,
            true
        );

        // 点击购买直购打包礼包
        Util.AddClickEvent(
            this.baleBox,
            () => {

                let infoDate = this.actDate.reward_list[this.actDate.reward_list.length - 1];
                let rechargeId: number = infoDate.grade;
                let conf: any = this.rechargeConf[rechargeId];
                let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                if (hasNum >= conf.money) {
                    this.UseToken(true);
                } else {
                    this.Pay(conf.money, conf.product_id, conf.product_name);
                }

            },
            this,
            true
        );

        Util.AddClickEvent(
            this.closeBox,
            () => {
                this.Close();
            },
            this,
            true
        );

        Util.AddClickEvent(
            this.descBox,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.OneDollarSpike)
            },
            this,
            true
        );



        this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UPDATE_VIEW, (...new_args) => {
            let args = new_args;
            if (this.actInfo.base_type == args[0] && this.actInfo.sub_type == args[1]) {
                /* if (args[3] && args[3].reward) {
                    let reward = CustomActivityModel.GetInstance().GetActReward(args[0], args[1], args[3].form_type, args[3].reward)
                    if (reward && reward.length) {
                        let view = new CongratulationObtainView(reward, 10)
                        view.Open()
                    }
                } */

                this.actInfo = CustomActivityModel.GetInstance().GetActInfo(args[0], args[1]);
                if (args[2]) {
                    this.actDate = args[2];
                    ActivityIconManager.GetInstance().deleteIcon('331@115@0');
                } else {
                    this.actDate = CustomActivityModel.GetInstance().GetActData(args[0], args[1]);
                    this.DeleteActIcon();
                }
                this.RenderView();

                // this.UpdateRedDot();
            }

        });


        // 选择页签回调
        this.BindEvent(this.OneDollarSpikeModel, OneDollarSpikeModelEvent.TAB_SELECT, (data: any, index: number) => {
            this.defTabIndex = index;
            this.loop_mgr1.SetSelectIndex(this.defTabIndex);
            this.RenderAwardList();
            this.UpdateView();
            // this.UpdateRedDot();
        });

    }


    private RenderView() {
        this.actDate.reward_list.sort((a: any, b: any) => {
            return a.grade - b.grade;
        });
        this.SetDefIndex();
        this.RenderTabList();
        this.RenderAwardList();
        this.UpdateView();
        this.UpdateRedDot();
    }

    private UpdateView() {
        let lenData = this.actDate.reward_list[this.actDate.reward_list.length - 1];
        let infoDate = this.actDate.reward_list[this.defTabIndex];
        let condition = ErlangParser.GetInstance().parse(infoDate.condition);
        let lenCond = ErlangParser.GetInstance().parse(lenData.condition);
        let balePrice: number = +lenCond[0][1];
        this.priceLab.text = `原价${condition[1][1][0]}元`;
        this.spikeLab.text = `${infoDate.name}`;
        this.titleNameLab.text = `${condition[1][1][1]}元礼包内容:`
        this.baleLab.text = `${lenData.name}`;

        this.baleBox.visible = balePrice < this.GetCurNotBuyTotalNum();
        this.titleImg1.visible = balePrice < this.GetCurNotBuyTotalNum();
        this.buyImg.visible = infoDate.status > 0
        this.spikeBox.visible = infoDate.status == 0;

    }


    private RenderAwardList() {
        let list = ErlangParser.GetInstance().parse(this.actDate.reward_list[this.defTabIndex].reward);
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.awardList,
                OneDollarSpikeAwardItem,
                list,
                LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr.replaceAll(list);
        }
    }

    private RenderTabList() {
        let list: string[] = ErlangParser.GetInstance().parse(this.actInfo.condition)[1][2];
        let tabs: { id: number, price: number, red: boolean }[] = [];
        for (const iterator of this.actDate.reward_list) {
            let condition = ErlangParser.GetInstance().parse(iterator.condition);
            if (list.indexOf(condition[0][1]) != -1) {
                tabs.push({ id: condition[0][1], price: condition[1][1][1], red: !Boolean(iterator.status) })
            }
        }


        if (!this.loop_mgr1) {
            this.loop_mgr1 = new LoopScrowViewMgr();
            this.loop_mgr1.SetData(
                this.tabList,
                OneDollarSpikeTabItem,
                tabs,
                LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr1.replaceAll(tabs);
        }

        this.loop_mgr1.SetSelectIndex(this.defTabIndex);


    }


    public Open(...new_args) {
        this._Local_Open(new_args)
    }

    private _Local_Open(parms: any) {
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

        this.ClearUIEffect(this.effectBox);

        super.DeleteMe();
    }

    private GetActDate() {
        if (!this.actInfo) {
            return;
        }
        this.actDate = CustomActivityModel.GetInstance().GetActData(this.actInfo.base_type, this.actInfo.sub_type);
    }



    /**
     * 获取当前未购买礼包的总金额
     */
    private GetCurNotBuyTotalNum() {
        let totalNum: number = 0;
        for (const iterator of this.actDate.reward_list) {
            if (iterator.form_type) {
                if (iterator.status == 0) {
                    let condition = ErlangParser.GetInstance().parse(iterator.condition);
                    totalNum += (+condition[1][1][1]);
                }
            }
        }

        return totalNum;
    }

    private SetDefIndex() {
        for (let index = this.actDate.reward_list.length - 1; index >= 0; index--) {
            const iterator = this.actDate.reward_list[index];
            if (iterator.form_type) {
                if (iterator.status == 0) {
                    this.defTabIndex = index;
                    break;
                }
            }
        }
    }

    private UpdateRedDot() {
        /*     let flag: boolean = false;
            for (let index = 0; index < this.actDate.reward_list.length; index++) {
                const iterator = this.actDate.reward_list[index];
                if (iterator.form_type) {
                    if (iterator.status == 0) {
                        flag = true;
                        break;
                    }
                }
            }
    
            if (!flag) {
            } */
        CustomActivityModel.GetInstance().CloseACTRed(this.actInfo.base_type, this.actInfo.sub_type);

    }

    /**
     * 使用代币
     */
    private UseToken(isAll: boolean = false) {
        let infoDate = isAll ? this.actDate.reward_list[this.actDate.reward_list.length - 1] : this.actDate.reward_list[this.defTabIndex];
        let rechargeId: number = isAll ? infoDate.grade : ErlangParser.GetInstance().parse(infoDate.condition)[0][1];
        let conf: any = this.rechargeConf[rechargeId];
        VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', conf.product_id);
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
     * 处理主界面图标
    */
    private DeleteActIcon() {
        if (OneDollarSpikeModel.GetInstance().GetDollarSpikeAllBuy(this.actInfo.base_type, this.actInfo.sub_type)) {
            ActivityIconManager.GetInstance().deleteIcon('331@115@0');
        }
    }

    bgImg: Laya.Image
    priceLab: Laya.Label
    titleNameLab: Laya.Label
    buyImg: Laya.Image
    titleImg: Laya.Image
    titleImg1: Laya.Image
    tabList: Laya.List
    awardList: Laya.List
    spikeBox: Laya.Box
    spikeLab: Laya.Label
    baleBox: Laya.Box
    baleLab: Laya.Label
    closeBox: Laya.Box
    descBox: Laya.Box
    effectBox: Laya.Box
    public GetComponents() {
        [
            this.bgImg,
            this.priceLab,
            this.titleNameLab,
            this.buyImg,
            this.titleImg,
            this.titleImg1,
            this.tabList,
            this.awardList,
            this.spikeBox,
            this.spikeLab,
            this.baleBox,
            this.baleLab,
            this.closeBox,
            this.descBox,
            this.effectBox,
        ]
            = this.GetChildrenByNames([

                "bgImg",
                "priceLab",
                "titleNameLab",
                "buyImg",
                "titleImg",
                "titleImg1",
                "tabList",
                "awardList",
                "spikeBox",
                "spikeLab",
                "baleBox",
                "baleLab",
                "closeBox",
                "descBox",
                "effectBox",
            ])
    }
}
window["OneDollarSpikeView"] = OneDollarSpikeView