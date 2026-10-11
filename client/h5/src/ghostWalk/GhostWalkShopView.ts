import { Util } from '../util/Util';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { BaseView1 } from '../common/BaseView1';
import { ShopEvent, ShopModel, ShopType } from '../commonModel/ShopModel';
import { GhostWalkShopItem } from './GhostWalkShopItem';
import { ResManager } from '../common/ResManager';
import { GameResPath } from '../util/GameResPath';
import { GoodsModel } from '../commonModel/GoodsModel';

export class GhostWalkShopView extends BaseView1 {
    private loop_mgr: LoopScrowViewMgr;
    private shopModel: ShopModel;
    private moneyType = 36240001;
    public constructor() {
        super();
        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkShopView';
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        this.change_scene_close = true;
        this.shopModel = ShopModel.GetInstance();
        this.load_callback = () => {
            this.initView();
            this.initEvent();
        };
        this.open_callback = this.initView;
    }

    private initView() {
        this.shopModel.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15301, 'c', ShopType.GhostWalk);
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgBg, GameResPath.GetIconOtherPath('ghostWalk', 'ui_bai_04'));
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgHead, GameResPath.GetIconOtherPath('ghostWalk', 'ui_gift_02'));
    }

    private initEvent() {
        let success_fun = () => {
            this.lblNum.text = GoodsModel.GetInstance().GetSpecialScore(this.moneyType);
        };

        this.BindEvent(ShopModel.GetInstance(), ShopEvent.BUY_GOODS_SUCCESS, success_fun);
        this.BindEvent(this.shopModel, ShopEvent.UPDATE_SHOP_DATA, this.updateShopList.bind(this));
        Util.AddClickEvent(this.btnClose, this.Close.bind(this), this, true);
    }

    updateShopList() {
        let shopInfo = this.shopModel.GetShopDataByType(ShopType.GhostWalk).sort((a, b) => a.rank - b.rank);
        let moneyType = shopInfo[0]?.money_type || this.moneyType;
        this.moneyType = moneyType;
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgMoney, GameResPath.GetGoodsIconPath(String(moneyType)));
        this.lblNum.text = GoodsModel.GetInstance().GetSpecialScore(moneyType);
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this.listGoods, GhostWalkShopItem, shopInfo, LoopScrCon.Vertical);
        } else {
            this.loop_mgr.replaceAll(shopInfo);
        }
    }

    public DeleteMe() {
        super.DeleteMe();
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
    }
    imgBg: Laya.Image;
    imgHead: Laya.Image;
    imgMoney: Laya.Image;
    btnClose: Laya.Image;
    lblNum: Laya.Label;
    lblRefreshTime: Laya.Label;
    listGoods: Laya.List;
    public GetComponents() {
        [this.imgBg, this.imgHead, this.imgMoney, this.btnClose, this.lblNum, this.lblRefreshTime, this.listGoods] = this.GetChildrenByNames(['imgBg', 'imgHead', 'imgMoney', 'btnClose', 'lblNum', 'lblRefreshTime', 'listGoods']);
    }
}
window['GhostWalkShopView'] = GhostWalkShopView;
