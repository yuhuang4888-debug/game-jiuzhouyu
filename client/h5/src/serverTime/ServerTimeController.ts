import { BaseController } from "../common/BaseController";
import { ServerTimeModel } from "./ServerTimeModel";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { Util } from "../util/Util";
export class ServerTimeController extends BaseController {
    model: ServerTimeModel;
    static Instance: ServerTimeController;
    public constructor() {
        super();
        this.model = ServerTimeModel.GetInstance();
        this.InitInfo();
        this.InitEvent();
    }
    public static GetInstance() {
        if (!ServerTimeController.Instance) {
            ServerTimeController.Instance = new ServerTimeController();
        }
        return ServerTimeController.Instance;
    }
    private InitEvent = () => {
    };
    private InitInfo = () => {
        let On10201 = () => {
            let vo: any = {};
            vo.open_time = this.ReadFmt("i");
            vo.merge_time = this.ReadFmt("i");
            vo.merge_start_time = this.ReadFmt("i");
            vo.merge_count = this.ReadFmt("i");
            vo.server_time = this.ReadFmt("l");
            if (vo)
                this.model.InitServerTime(vo);
        };
        let On10205 = () => {
            let vo = UserMsgAdapter.GetInstance().GetSCMD(10205);
            Util.ErrorCodeShow(vo.error_code, vo.args);
        };
        this.RegisterProtocal(10201, On10201); //通用错误返回
        this.RegisterProtocal(10205, On10205);
    };
}

window["ServerTimeController"] = ServerTimeController