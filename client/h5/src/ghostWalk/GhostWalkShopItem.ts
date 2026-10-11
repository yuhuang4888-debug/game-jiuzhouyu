import { Alert, Alert_Type } from '../alert/Alert';
import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { MaterialsTool } from '../common/MaterialsTool';
import { ResManager } from '../common/ResManager';
import { BossModel } from '../commonModel/BossModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { ShopEvent, ShopModel, ShopType } from '../commonModel/ShopModel';
import { Message } from '../sysInfo/SysInfoController';
import { ColorUtil } from '../util/ColorUtil';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';

export class GhostWalkShopItem extends BaseItemRenderer {
    data;
    commodity: BaseAwardItem;
    WIDTH = 190;
    HEIGT = 233;
    public constructor() {
        super();
        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkShopItem';
        this.load_callback = () => {
            this.LoadSuccess();
        };
        this.Load();
    }

    public LoadSuccess() {
        this.htmlLimit.style.color = '#663915';
        this.htmlLimit.style.fontSize = 18;
        this.htmlLimit.style.wordWrap = false;

        Util.AddClickEvent(
            this.btnBuy,
            () => {
                if (this.data) {
                    let data = this.data;
                    if (data.sold_out >= data.quota_num) {
                        Message.show('没货了~');
                        return;
                    }
                    let enough = GoodsModel.GetInstance().GetSpecialScore(data.money_type) >= data.price;
                    if (!enough) {
                        MaterialsTool.GetInstance().materialsTips(data.money_type);
                        Message.show('货币不足');
                        return;
                    }
                    let OkFunc = () => {
                        ShopModel.GetInstance().Fire(ShopEvent.SHOP_REQUEST_PROTO, 15302, 'ii', this.data.key_id, 1);
                    };



                    //批量购买
                    if ((this.data.quota_num == 0 || this.data.sold_out < this.data.quota_num) && this.data.type != ShopType.Outward&&this.data.quota_num>=5) {
                        this.data.scmd = 15302
                        ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", this.data)
                        return
                    }

                    

                    if (!BossModel.NOT_EUDA_SHOP_ALERT) {
                        let CheckFunc = (bool?) => {
                            BossModel.NOT_EUDA_SHOP_ALERT = bool;
                        };

                        Alert.Show('是否消耗' + this.data.price + GoodsModel.GetGoodsNameWithColorDark(this.data.money_type) + '购买' + GoodsModel.GetGoodsNameWithColorDark(this.data.goods_id) + '*' + this.data.num + '?', Alert_Type.AlertTypeCheckBox, OkFunc, null, null, null, null, null, CheckFunc);
                    } else {
                        OkFunc();
                    }
                }
            },
            this,
            true
        );

        let refresh_fun = (key_id?) => {
            if (this.data && this.data.key_id == key_id) {
                this.data = ShopModel.GetInstance().GetShopDataByKeyId(key_id);
                this.SetData();
            }
        };

        this.BindEvent(ShopModel.GetInstance(), ShopEvent.UPDATE_SHOP_ONE_DATA, refresh_fun);
    }

    public dataChanged() {
        if (!super.dataChanged()) return;
        this.SetData();
    }

    public SetData() {
        this.imgLine.visible = this.index % 3 == 0;
        let data = this.data;
        let canBuy = data.quota_num > data.sold_out;
        let limitStr = '限购';
        if (this.data.quota_type == 1) {
            limitStr = '每日限购';
        } else if (this.data.quota_type == 2) {
            limitStr = '每周限购';
        } else if (this.data.quota_type == 3) {
            limitStr = '终生限购';
        }
        this.htmlLimit.innerHTML = `${limitStr} <font color='#0bb20f'>${data.quota_num - data.sold_out}/${data.quota_num}</font>`;
        this.btnBuy.gray = !canBuy;
        this.htmlLimit.x = 92 - this.htmlLimit.contextWidth / 2;
        this.lblPrice.text = data.price;
        if (!this.commodity) {
            this.commodity = new BaseAwardItem(this.goodsNode);
            this.commodity.Load();
            this.commodity.SetScale(0.7);
        }
        this.commodity.SetData(data.goods_id, data.num);
        this.commodity.SetGary(!canBuy);

        let goodsBasic2 = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.goods_id);
        if (goodsBasic2) {
            this.lblName.text = goodsBasic2.goods_name;
            this.lblName.color = ColorUtil.GetColorLight(goodsBasic2.color, false);
        }
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgMoney, GameResPath.GetGoodsIconPath(String(data.money_type)));
    }

    public DeleteMe() {
        if (this.commodity) {
            this.commodity.DeleteMe();
            this.commodity = null;
        }
        super.DeleteMe();
    }
    imgLine: Laya.Image;
    btnBuy: Laya.Image;
    imgMoney: Laya.Image;
    lblPrice: Laya.Label;
    lblName: Laya.Label;
    htmlLimit: Laya.HTMLDivElement;
    goodsNode: Laya.Sprite;
    public GetComponents() {
        [this.imgLine, this.btnBuy, this.imgMoney, this.lblPrice, this.lblName, this.htmlLimit, this.goodsNode] = this.GetChildrenByNames(['imgLine', 'btnBuy', 'imgMoney', 'lblPrice', 'lblName', 'htmlLimit', 'goodsNode']);
    }
}
window['GhostWalkShopItem'] = GhostWalkShopItem;
