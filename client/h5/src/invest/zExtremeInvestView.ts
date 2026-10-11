import { investType } from "../commonModel/KaifuActivityModel"
import { TopInvestView } from "./TopInvestView"

export class zExtremeInvestView extends TopInvestView {
    investType

    public static className = "zExtremeInvestView"
    public constructor(parent?) {
        super(parent)


        this.investType = investType.extreme
    }
}

window["zExtremeInvestView"] = zExtremeInvestView