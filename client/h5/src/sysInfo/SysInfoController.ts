import { SysInfoMiniMgr } from "./SysInfoMiniMgr";
import { SysInfoChuanwenMgr } from "./SysInfoChuanwenMgr";
import { SysGoodsMgr } from "./SysGoodsMgr";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { BaseView1 } from "../common/BaseView1";

export enum SysInfoType {
    MINI = 1,
    NOTICE = 2,
    CHUANWEN = 3,
    GOODS = 4,
    EXP = 5,
}
window["SysInfoType"] = SysInfoType;
export class SysInfoController {
    notice_mgr;
    static CLEAR_MSG_CACHE: string = "SIC.CLEAR_MSG_CACHE";
    static APPEND_MSG: string = "SIC.APPEND_MSG";
    InitEvent;
    AppendMsg;
    public constructor() {
        let mini_mgr = SysInfoMiniMgr.GetInstance(),chuanwen_mgr = SysInfoChuanwenMgr.GetInstance(), goods_mgr = SysGoodsMgr.GetInstance();
		//let exp_mgr = SysInfoExpMgr.GetInstance()
        let local_GlobalEventSystem = GlobalEventSystem, local_SysInfoController = SysInfoController, local_SysInfoType = SysInfoType;
        this.InitEvent = () => {
            local_GlobalEventSystem.Bind(local_SysInfoController.CLEAR_MSG_CACHE, (msg_type, type = SysInfoMiniMgr.MessageType.One) => {
                switch (msg_type) {
                    case local_SysInfoType.MINI:
                        mini_mgr.ClearMsgCache(type);
                        break;
                    case local_SysInfoType.CHUANWEN:
                        //chuanwen_mgr.ClearMsgCache()
                        break;
                    case local_SysInfoType.GOODS:
                        //goods_mgr.ClearMsgCache()
                        break;
                }
            });
            local_GlobalEventSystem.Bind(local_SysInfoController.APPEND_MSG, (msg_type, content, type) => {
                this.AppendMsg(msg_type, content, type);
            });
        };
        this.AppendMsg = (msg_type, content, type?) => {
            switch (msg_type) {
                case local_SysInfoType.MINI:
                    mini_mgr.AppendMiniMsg(content, type);
                    break;
                case local_SysInfoType.CHUANWEN:
                    chuanwen_mgr.AppendMessage(content, type);
                    break;
                case local_SysInfoType.GOODS:
                    goods_mgr.AppendGoods(content);
                    break
                case local_SysInfoType.EXP:
					mini_mgr.AppendMiniMsg(content, SysInfoMiniMgr.MessageType.Three)
                    break
            }
        }
        this.InitEvent()
    }
}
export class Message {
    public static show(content, show_in_main_layer = false, show_type = SysInfoType.MINI, mini_type = SysInfoMiniMgr.MessageType.One) {
        if (show_in_main_layer) {
            if (mini_type == SysInfoMiniMgr.MessageType.One) {
                if (!Util.IsTableEmpty(BaseView1.NOT_SHOW_MAIN_MSG_OPEN_VIEW)) {
                    return;
                }
            }
            else if (mini_type == SysInfoMiniMgr.MessageType.Two) {
                if (!Util.IsTableEmpty(BaseView1.NOT_SHOW_ATTR_MAIN_MSG_OPEN_VIEW)) {
                    return;
                }
            }
        }
        GlobalEventSystem.Fire(SysInfoController.APPEND_MSG, SysInfoType.MINI, content, mini_type);
        // SysInfoController.GetInstance().AppendMsg(SysInfoType.MINI, content, mini_type)
    }

    public static showGoods(goodsVo) {
        GlobalEventSystem.Fire(SysInfoController.APPEND_MSG, SysInfoType.GOODS, goodsVo);
        // SysInfoController.GetInstance().AppendMsg(SysInfoType.GOODS, goodsVo)
    }

    public static showExp(value){
        GlobalEventSystem.Fire(SysInfoController.APPEND_MSG, SysInfoType.EXP, value);
    }

}
window["Message"] = Message;

window["SysInfoController"] = SysInfoController