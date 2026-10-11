import { UserMsgAdapter } from "./UserMsgAdapter";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { BaseClass } from "./BaseClass";
import { GlobalTimerQuest } from "../util/Util";
// TypeScript file
let local_UserMsgAdapter = UserMsgAdapter
let local_GlobalEventSystem = GlobalEventSystem
export class BaseController extends BaseClass {
    static request_protocals_list: Array<any> = [];
    static handle_protocals = {};
    static is_delay_send_protocal = false;
    static delay_timer_id;
    public constructor() {
        super();
    }
    /**
        功能:	注册一条协议的响应函数
        参数:
                id 协议号
                func_name 继承ProtocalBase类的成员函数名称
        返回值:
                无
        其它:	无
        */
    RegisterProtocal<P extends Proto>(id: P, register_func: (scmd?: ProtoRecvVObj<P>) => void) {
        if (typeof (register_func) == "string") {
            register_func = this[register_func]
        }
        local_UserMsgAdapter.GetInstance().RegisterMsgOperate(id, register_func);
    };
    SendFmtToGame<P extends Proto>(cmd: P, fmt_str?: ProtoSendFmts<P>, ...other: ProtoSendArgs<P> | Array<any>) {
        if (local_BaseController.is_delay_send_protocal || local_BaseController.request_protocals_list.length > 0) {
            let vo = { cmd: cmd, fmt_str: fmt_str, args: other };
            local_BaseController.request_protocals_list.push(vo);
            if (!local_BaseController.delay_timer_id) {
                local_BaseController.delay_timer_id = GlobalTimerQuest.AddPeriodQuest(local_BaseController.DelaySendFmtToGame, 20);
            }
        }
        else {
            local_UserMsgAdapter.GetInstance().SendAllFmtToGame(cmd, fmt_str, other);
        }
    };
    WriteBegin(cmd) {
        local_UserMsgAdapter.GetInstance().WriteBegin(cmd);
    };
    WriteFMT(fmt_str, ...other) {
        local_UserMsgAdapter.GetInstance().WriteFMT(fmt_str, other);
    };
    SendToGame() {
        local_UserMsgAdapter.GetInstance().SendToGame();
    };
    /**
    功能:	从协议缓冲区按格式化字符串读取内容
    参数:
            fmt_str 格式化字符串(参见文件头部说明) string
    返回值:
            根据格式化字符串返回多个值
    其它:	无
   */
    ReadFmt(fmt_str) {
        return local_UserMsgAdapter.GetInstance().ReadFmt(fmt_str);
    };
    Bind(event_id, event_func) {
        return local_GlobalEventSystem.Bind(event_id, event_func);
    };
    UnBind(obj) {
        local_GlobalEventSystem.UnBind(obj);
    };
    Fire(event_id, ...other) {
        local_GlobalEventSystem.Fire(event_id, ...other);
    };
    SendFmtToGameImme(cmd, fmt_str?, ...other) {
        local_UserMsgAdapter.GetInstance().SendAllFmtToGame(cmd, fmt_str, other);
    }
    public static DelaySendFmtToGame() {
        let size = local_BaseController.request_protocals_list.length;
        if (size <= 10 && !local_BaseController.is_delay_send_protocal) {
            if (local_BaseController.delay_timer_id) {
                GlobalTimerQuest.CancelQuest(local_BaseController.delay_timer_id);
                local_BaseController.delay_timer_id = null;
            }
        }
        if (size > 0) {
            size = Math.min(size, 10);
            for (let i = 0; i < size; i++) {
                let vo = local_BaseController.request_protocals_list.shift();
                if (vo) {
                    local_UserMsgAdapter.GetInstance().SendAllFmtToGame(vo.cmd, vo.fmt_str, vo.args);
                }
            }
        }
    }
}
let local_BaseController = BaseController
window["BaseController"] = BaseController