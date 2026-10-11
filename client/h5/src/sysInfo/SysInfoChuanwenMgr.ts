import { ChuanwenItem } from "./ChuanwenItem";
import  "../sysInfo/ChuanwenItem2";
import { ChuanwenSpecItem } from "./ChuanwenSpecItem";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
export class SysInfoChuanwenMgr {
    public static Instance: SysInfoChuanwenMgr;
    public static MAX_MSG_COUNT = 10;
    // private msg_con: Laya.Box
    public has_text = false;
    InitMgr;
    AppendMessage;
    ShowNextMsg;
    AppendItemMseeage;
    GetSpItemIndex;
    public constructor() {
        let item_: ChuanwenItem, specitem_: ChuanwenSpecItem, msg_dic_ = { "1": [], "4": [] }, //信息数据 [type,list]
        msg_type_list_ = [4, 1];
        this.InitMgr = () => {
            let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top);
            item_ = new ChuanwenItem(layer);
            specitem_ = new ChuanwenSpecItem(layer);
        };
        this.AppendMessage = (content, type) => {
            if (msg_dic_[type].length >= SysInfoChuanwenMgr.MAX_MSG_COUNT) {
                msg_dic_[type].shift();
            }
            if (!this.has_text) {
                this.AppendItemMseeage(type, content);
            }
            else {
                msg_dic_[type].push(content);
            }
        };
        this.ShowNextMsg = () => {
            for (let type of msg_type_list_) {
                let content = msg_dic_[type].shift();
                if (!content)
                    continue;
                this.AppendItemMseeage(type, content);
                return type;
            }
        };
        this.AppendItemMseeage = (type, content) => {
            if (type == 1) {
                if (item_.is_loaded) {
                    item_.AppendMessage(content);
                }
            }
            else if (type == 4) {
                if (specitem_.is_loaded) {
                    specitem_.AppendMessage(content);
                }
            }
        };
        this.GetSpItemIndex = () => {
            return specitem_ ? specitem_._parent.getChildIndex(specitem_) : 0;
        };
        this.InitMgr();
    }
    public static GetInstance() {
        if (!SysInfoChuanwenMgr.Instance) {
            SysInfoChuanwenMgr.Instance = new SysInfoChuanwenMgr();
        }
        return SysInfoChuanwenMgr.Instance;
    }
}

window["SysInfoChuanwenMgr"] = SysInfoChuanwenMgr