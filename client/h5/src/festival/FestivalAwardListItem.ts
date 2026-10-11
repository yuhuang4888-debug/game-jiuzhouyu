import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { ResManager } from '../common/ResManager';
import { EnumFestivalProtocol } from '../commonController/FestivalController';
import { FestivalModel, FestivalModelEvent, ICConfFiestaLvExp, IS2CFestivalBasicInfo, IS2CFestivalBasicInfoRewaed } from '../commonModel/FestivalModel';
import { RoleManager } from '../commonModel/RoleManager';
import { ShopEvent, ShopModel } from '../commonModel/ShopModel';
import { MainRoleVo } from '../sharedata/MainRoleVo';
import { GameResPath } from '../util/GameResPath';
import { NotEnougnDiamond, Util } from '../util/Util';
import { ErlangParser } from './../util/ErlangParser';
import { FestivalBaseView } from './FestivalBaseView';
import { FestivalUpLevelTipsView } from './FestivalUpLevelTipsView';
export class FestivalAwardListItem extends BaseItemRenderer {


    WIDTH = 570
    HEIGT = 136

    private item1: BaseAwardItem;
    private item2: BaseAwardItem;

    private readonly goosId: number = 37120001; // 拿这个商品id做经验换算;

    private get FestivalModel() {
        return FestivalModel.GetInstance();
    }

    public constructor() {
        super();
        this.base_file = 'festival';
        this.layout_file = 'FestivalAwardListItem';

        this.load_callback = () => {
            this.InitEvents();
            this.LoadSuccess();
        };
        this.Load();

    }

    private LoadSuccess() {
        // 加载位图字体
        this.lvLab.fontSize = 32
        ResManager.GetInstance().LoadFont(this, "festival_level", this.lvLab, 32);
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.imgBg1,
            GameResPath.GetIconOtherPath('festival', 'ui_db_jd011')
        );
        if (!this.item1) {
            this.item1 = new BaseAwardItem(this.iconBox1);
            this.item1.Load();
            this.item1.SetItemSize(85, 85)
        }

        if (!this.item2) {
            this.item2 = new BaseAwardItem(this.iconBox2);
            this.item2.Load();
            this.item2.SetItemSize(85, 85);
        }

    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data: ICConfFiestaLvExp = this.data;
            let info: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
            // 当前等级对应索引
            let levelInfo: IS2CFestivalBasicInfoRewaed = this.FestivalModel.GetLevelMap(data.lv);
            let curLvIndex: number = this.FestivalModel.GetFetivalCurLevelByIndex();
            // == -1 && info.lv > 0 
            // ? this.index + 1 
            // : this.FestivalModel.GetFetivalCurLevelByIndex();

            if (data?.isOrder) {
                this.upBtn.visible = false;
                this.getBtn.visible = false;
                this.getImg.visible = false;
                this.notImg.visible = true;
                this.imgBg1.visible = false;
                this.buyBtn.visible = false;
            } else {
                if (this.index <= curLvIndex) {
                    if (levelInfo) {
                        // 判断是否购买高级祭典
                        if (this.FestivalModel.GetFestivalIsBuy()) {
                            this.getBtn.visible = (levelInfo.status1 == 1 || levelInfo.status2 == 1);
                            this.redImg.visible = (levelInfo.status1 == 1 || levelInfo.status2 == 1);
                            this.getImg.visible = !(levelInfo.status1 == 1 || levelInfo.status2 == 1);
                            this.upBtn.visible = false;
                            this.notImg.visible = false;
                            this.get2Img.visible = levelInfo.status2 == 2;
                            this.get1Img.visible = levelInfo.status1 == 2;
                            this.buyBtn.visible = false;
                        } else {
                            this.getBtn.visible = (levelInfo.status1 == 1);
                            this.redImg.visible = (levelInfo.status1 == 1);
                            // this.getImg.visible = !(levelInfo.status1 == 1);
                            this.upBtn.visible = false;
                            this.notImg.visible = false;
                            this.get1Img.visible = levelInfo.status1 == 2;
                            this.buyBtn.visible = (levelInfo.status1 == 2 && levelInfo.status2 != 2)
                        }
                    } else {
                        this.upBtn.visible = true;
                        this.getBtn.visible = false;
                        this.getImg.visible = false;
                        this.notImg.visible = false;
                        this.buyBtn.visible = false;
                    }
                } else if (this.index == curLvIndex + 1) {
                    this.upBtn.visible = true;
                    this.getBtn.visible = false;
                    this.getImg.visible = false;
                    this.notImg.visible = false;
                    this.get1Img.visible = false;
                    this.get2Img.visible = false;
                    this.buyBtn.visible = false;
                } else {
                    this.upBtn.visible = false;
                    this.getBtn.visible = false;
                    this.getImg.visible = false;
                    this.notImg.visible = true;
                    this.get1Img.visible = false;
                    this.get2Img.visible = false;
                    this.buyBtn.visible = false;
                }
            }

            this.RenderReward(data)

        }
    }


    private RenderReward(data: ICConfFiestaLvExp) {
        let reward = ErlangParser.GetInstance().parse(data.reward);
        if (reward.length > 0) {
            this.iconBox1.visible = true;
            if (!this.item1) {
                this.item1 = new BaseAwardItem(this.iconBox1);
            }
            this.item1.Load();
            this.item1.SetItemSize(85, 85);
            this.item1.SetData(reward[0][1], reward[0][2]);
        } else {
            this.iconBox1.visible = false;
        }

        let premiumReward = ErlangParser.GetInstance().parse(data.premium_reward);
        if (premiumReward.length > 0) {
            this.iconBox2.visible = true;
            if (!this.item2) {
                this.item2 = new BaseAwardItem(this.iconBox2);
            }
            this.item2.Load();
            this.item2.SetItemSize(85, 85);
            this.item2.SetData(premiumReward[0][1], premiumReward[0][2]);
            this.lockImg.visible = !this.FestivalModel.GetFestivalIsBuy();
        } else {
            this.iconBox2.visible = false;
            this.lockImg.visible = false;
        }

        this.lvLab.text = `${data.lv}`;
        this.lvLab.x = data.lv >= 100 ? 40 : data.lv >= 10 ? 62 : 77;
        this.lvLab.y = 25;

        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.imgBg2,
            GameResPath.GetIcon('festival', data?.isOrder ? 'ui_db_jd021' : 'ui_db_jd020')
        );
    }

    private InitEvents() {
        // 点击领取奖励
        let GetAward = () => {
            if (this.data) {
                this.FestivalModel.Fire(FestivalModelEvent.FESTIVAL_REQUEST_PROTO, EnumFestivalProtocol.eProtocol19402, 'h', this.data.lv);
            }
        }
        Util.AddClickEvent(this.getBtn, GetAward, this, true);

        // 点击升级跳转
        let GoJump = () => {
            if (this.FestivalModel.loginTips) {
                this.BuyGoods();
            } else {
                this.FestivalModel.Fire(
                    FestivalModelEvent.OPEN_FESTIVAL_VIEW, FestivalUpLevelTipsView._layout_file, this.FestivalModel.GetFetivalCurLvToNextLvCostExpNum()
                );
            }
        }
        Util.AddClickEvent(this.upBtn, GoJump, this, true);

        // 点击升级跳转
        let GoJump1 = () => {
            this.FestivalModel.Fire(
                FestivalModelEvent.OPEN_FESTIVAL_VIEW,
                FestivalBaseView._layout_file,
                2
            );
        }
        Util.AddClickEvent(this.buyBtn, GoJump1, this, true);



    }


    /**
     * 点击购买
     */
    private BuyGoods() {
        let conf = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_quick_buy_price", false)
        let goldPrice: number = conf[this.goosId.toString()]['gold_price'];
        let mainVo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo();
        let curNum: number = this.FestivalModel.GetFetivalCurLvToNextLvCostExpNum();
        let sumCost: number = curNum * goldPrice;

        if (mainVo.jin >= sumCost) {
            ShopModel.GetInstance().Fire(ShopEvent.SHOP_REQUEST_PROTO, 15304, "iic", this.goosId, curNum, 1);
        } else {
            NotEnougnDiamond();
        }

    }

    public DeleteMe() {
        if (this.item1) {
            this.item1.DeleteMe();
            this.item1 = null;
        }
        if (this.item2) {
            this.item2.DeleteMe();
            this.item2 = null;
        }
        super.DeleteMe();
    }



    imgBg1: Laya.Image
    imgBg2: Laya.Image
    lvLab: Laya.Label
    iconBox1: Laya.Box
    iconBox2: Laya.Box
    lockImg: Laya.Image
    getBtn: Laya.Box
    redImg: Laya.Image
    upBtn: Laya.Box
    getImg: Laya.Image
    notImg: Laya.Image
    get1Img: Laya.Image
    get2Img: Laya.Image
    buyBtn: Laya.Box
    public GetComponents() {
        [
            this.imgBg1,
            this.imgBg2,
            this.lvLab,
            this.iconBox1,
            this.iconBox2,
            this.lockImg,
            this.getBtn,
            this.redImg,
            this.upBtn,
            this.getImg,
            this.notImg,
            this.get1Img,
            this.get2Img,
            this.buyBtn,
        ]
            = this.GetChildrenByNames([

                "imgBg1",
                "imgBg2",
                "lvLab",
                "iconBox1",
                "iconBox2",
                "lockImg",
                "getBtn",
                "redImg",
                "upBtn",
                "getImg",
                "notImg",
                "get1Img",
                "get2Img",
                "buyBtn",
            ])
    }
}
window["FestivalAwardListItem"] = FestivalAwardListItem