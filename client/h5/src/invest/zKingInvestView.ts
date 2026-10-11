import { investType } from "../commonModel/KaifuActivityModel"
import { TopInvestView } from "./TopInvestView"

export class zKingInvestView extends TopInvestView {
    investType

    public static className = "zKingInvestView"
    public constructor(parent?) {
        super(parent)

        this.investType = investType.king
    }
}

window["zKingInvestView"] = zKingInvestView