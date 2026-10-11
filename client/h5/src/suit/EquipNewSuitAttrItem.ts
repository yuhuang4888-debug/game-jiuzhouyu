import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { EquipModel } from "../commonModel/EquipModel";
import { IS2CSuitListPowerInfoParam, SuitModel, SuitModelEvent } from "../commonModel/SuitModel";
import { Util } from "../util/Util";

export class EquipNewSuitAttrItem extends BaseItemRenderer {

    public WIDTH = 299;
    public HEIGT = 170;

    private _combat: FightingShowSmallItem;

    private get suitModel() {
        return SuitModel.GetInstance();
    }

    public constructor() {
        super();
        this.base_file = "suit";
        this.layout_file = "EquipNewSuitAttrItem";

        this.load_callback = () => {
            this.InitEvents();
            this.LoadSuccess();

        }
        this.Load();

    }

    private InitEvents() {
        // 请求战力回调
        this.BindEvent(
            this.suitModel,
            SuitModelEvent.UP_SUIT_POWER, () => {
                this.RenderPower();
            }
        )
    }

    private LoadSuccess() {
        if (!this._combat) {
            this._combat = new FightingShowSmallItem(this.combatBox);
            this._combat.Load();
        }
    }

    public DeleteMe() {
        if (this._combat) {
            this._combat.DeleteMe();
            this._combat = null;
        }
        super.DeleteMe();
    }


    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data;
            if (!this._combat) {
                this._combat = new FightingShowSmallItem(this.combatBox);
                this._combat.Load();
            }

            let curNum: number = this.suitModel.GetTypePosLevelNum(data.suitType, data.subType, data.pos, data.lv);
            let color: string = curNum >= data[0] ? '#0A953E' : '#676767';
            this.numLab.text = `${data[0]}件`;

            this.numLab.color = color;
            this.attrHtml.style.fontSize = 20;
            this.attrHtml.style.color = color;
            this.attrHtml.style.leading = 6;
            this.attrHtml.style.width = 200;
            this.attrHtml.innerHTML = Util.StrToHTML(EquipModel.GetInstance().GetAttrStr(data[1], color));

            this.RenderPower();
        }
    }

    /**
     * 渲染战力
     * @returns 
     */
    private RenderPower() {
        if (!(this.is_loaded && this.data)) {
            return;
        }
        let data = this.data;
        let powers: IS2CSuitListPowerInfoParam[] = this.suitModel.GetSuitsPower(data.pos, data.subType, data.lv);
        if (powers) {
            let power: IS2CSuitListPowerInfoParam = powers.find((power: IS2CSuitListPowerInfoParam) => {
                return data[0] == power.num;
            });

            if (power) {
                this._combat.Updatefighting(power.combat);
            } else {
                this._combat.Updatefighting(Util.CalAttrPower(data[1]));
            }
        } else {
            this._combat.Updatefighting(Util.CalAttrPower(data[1]));
        }
    }


    numLab: Laya.Label
    combatBox: Laya.Box
    attrHtml: Laya.HTMLDivElement
    lineImg: Laya.Image
    public GetComponents() {
        [
            this.numLab,
            this.combatBox,
            this.attrHtml,
            this.lineImg,
        ]
            = this.GetChildrenByNames([

                "numLab",
                "combatBox",
                "attrHtml",
                "lineImg",
            ])
    }
}
window["EquipNewSuitAttrItem"] = EquipNewSuitAttrItem