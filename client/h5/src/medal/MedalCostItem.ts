import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel";
import { EnumMedalCostType, MedalCostParam } from "../commonModel/MedalModel";
import { RoleManager } from "../commonModel/RoleManager";


export class MedalCostItem extends BaseItemRenderer {

    public WIDTH = 385;
    public HEIGT = 34;

    private _item: BaseAwardItem;

    public constructor() {
        super()

        this.base_file = "medal"
        this.layout_file = "MedalCostItem"
        this.load_callback = () => {
            this.LoadSuccess()
        }
        this.Load();
    }

    public DeleteMe() {

        if (this._item) {
            this._item.DeleteMe()
            this._item = null
        }
        super.DeleteMe()
    }

    public LoadSuccess() {
        // this.display_obj.scale(0.9,0.9)
        if (!this._item) {
            this._item = new BaseAwardItem(this.iconBox)
            this._item.SetItemSize(85, 85);
            this._item.Load();
        }
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data: MedalCostParam = this.data;
            if (!data) return;

            if (!this._item) {
                this._item = new BaseAwardItem(this._item);
                this._item.Load();
            }
            this._item.SetItemSize(30, 30);
            this._item.SetItembgVisible(false);

            this.iconBox.visible = data.type == EnumMedalCostType.eItem;
            let curNum: number = 0;
            let costNum: number = 0;
            switch (data.type) {
                case EnumMedalCostType.ePower:
                    let rolePower: number = RoleManager.GetInstance().GetMainRoleVo().fighting;
                    this.descLab.text = '所需战力:';
                    curNum = rolePower;
                    costNum = Number(data.con);
                    break;
                case EnumMedalCostType.eLayerNum:
                    this.descLab.text = '御魂塔数:';
                    curNum = data.layerNum;
                    let otherCondition = JSON.parse(String(data.con));
                    costNum = otherCondition[0][1];
                    break;
                case EnumMedalCostType.eItem:
                    this.descLab.text = '所需道具:';
                    let costItem = JSON.parse(String(data.con));
                    costNum = costItem[0][2];
                    curNum = GoodsModel.GetInstance().GetTypeGoodsNum(costItem[0][1]);
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(costItem[0][0], costItem[0][1]);
                    this._item.SetData(type_id, costNum, lock);
                    break;
            }


            let bool: boolean = curNum >= costNum;
            this.gouImg.visible = bool;
            this.chaImg.visible = !bool;
            this.lImg.visible = bool;
            this.hImg.visible = !bool;
            let color: string = bool ? '#0A953E' : '#FE1A1A';

            this.curNum.text = curNum + '';
            this.nextLab.text = '/' + costNum;
            this.curNum.color = this.nextLab.color = color;

            // 计算位置
            this.curNum.x = !this.iconBox.visible ? this.iconBox.x : 151;
            this.nextLab.x = this.curNum.x + this.curNum.width;
            this.gouImg.x = this.nextLab.x + this.nextLab.width + 15;
            this.chaImg.x = this.nextLab.x + this.nextLab.width + 19;



        }
    }







    lImg: Laya.Image
    hImg: Laya.Image
    descLab: Laya.Label
    iconBox: Laya.Box
    curNum: Laya.Label
    nextLab: Laya.Label
    gouImg: Laya.Image
    chaImg: Laya.Image
    public GetComponents() {
        [
            this.lImg,
            this.hImg,
            this.descLab,
            this.iconBox,
            this.curNum,
            this.nextLab,
            this.gouImg,
            this.chaImg,
        ]
            = this.GetChildrenByNames([

                "lImg",
                "hImg",
                "descLab",
                "iconBox",
                "curNum",
                "nextLab",
                "gouImg",
                "chaImg",
            ])
    }
}
window["MedalCostItem"] = MedalCostItem