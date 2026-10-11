import { UserMsgAdapter } from "./UserMsgAdapter";
import { Config } from "./Config";
import { Util } from "../util/Util";
/**
 *     int:8  类型 (0物品 1元宝 2绑定元宝 3铜币 4结社币 5经验 6鲜花值 7花香值 8结社资金 9结社贡献度 10结社声望 11副本声望 12竞技声望 13跨服声望)
                (14战场声望 15英灵装备 16 3v3声望 17使魔水晶 18秘钥 20御魂物品 21vip经验 100绑定物品 101绑定+限时物品)
    int:32 类型id
    int:32 数量
    int:8  绑定属性（类型为100和101时才有此字段）
    int:32 剩余期限（类型为100和101时才有此字段）
 */
export class DropList {
    drop_list: Array<any>;
    error_code;
    public constructor() {
        this.ReadFmt();
    }
    private ReadFmt() {
        let self = this, user_msg_adapter = UserMsgAdapter.GetInstance();
        self.error_code = user_msg_adapter.ReadFmt("i");
        if (self.error_code == 1) {
            self.drop_list = [];
            let len = user_msg_adapter.ReadFmt("h");
            if (len > 0) {
                let vo;
                for (let i = 0; i < len; i++) {
                    vo = {};
                    vo.type = user_msg_adapter.ReadFmt("c");
                    vo.type_id = user_msg_adapter.ReadFmt("i");
                    let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[vo.type];
                    if (vo.type != 0 && cfg) {
                        vo.type_id = cfg.goods_id;
                    }
                    vo.count = user_msg_adapter.ReadFmt("i");
                    if (vo.type == 100 || vo.type == 101 || vo.type == 255) {
                        vo.bind_pro = user_msg_adapter.ReadFmt("c");
                        vo.left_time = user_msg_adapter.ReadFmt("i");
                    }
                    self.drop_list.push(vo);
                }
            }
        }
        else {
            Util.ErrorCodeShow(self.error_code);
        }
        return null;
    }
}

window["DropList"] = DropList