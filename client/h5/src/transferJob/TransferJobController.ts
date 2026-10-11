import { BaseController } from "./../common/BaseController"
import { ResManager } from "../common/ResManager"
export class TransferJobCardController extends BaseController {
    data: number[][];
    viewDic;
    private static _instance: TransferJobCardController;
    model: {
        careerCfg?,
        transferCfg?: {
            TransferCareerMsg: any[]
        }
    };
    constructor() {
        super();
        this.model = {};
    }
    static get ins() {
        if (!TransferJobCardController._instance) {
            TransferJobCardController._instance = new TransferJobCardController()
        }
        return TransferJobCardController._instance;
    }
    async init() {
        this.model.careerCfg = await ResManager.GetInstance().LoadGameConfig(this, "config_career", false, null)
        this.model.transferCfg = await ResManager.GetInstance().LoadGameConfig(this, "ClientTransfer", true, null)
    }
    getCareerCfg(career) {
        return this.model.transferCfg['TransferCareerMsg'].find(item => item?.career == career)
    }
}