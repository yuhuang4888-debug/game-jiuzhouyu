/** 周卡信息
 */
declare interface ProtoFmtInfo {
    45201: {
        desc: "查看周卡信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 周卡等级 */
            lv: number;
            /** 当前vip经验值 */
            exp: number;
            /** 是否激活 0 未激活1 激活 */
            is_activity: number;
            /** 已领取礼包数量 */
            gift_bag_num: number;
            /** 可领取礼包数量 */
            can_receive_gift: number;
            /** 过期时间 */
            expired_time: number;
        };
    };
    45202: {
        desc: "一键领取礼包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            reward_list: {
                /** 物品大类型 */
                style: number;
                /** 物品id */
                typeId: number;
                /** 数量 */
                count: number;
            }[];
        };
    };
    45203: {
        desc: "未开通的补发奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1.未激活补发奖励列表 2.已激活补发奖励列表 3.未激活预补发奖励第一次有数据时红点 */
            type: number;
            reward: {
                /** 物品大类型 */
                style: number;
                /** 物品id */
                type_id: number;
                /** 数量 */
                count: number;
            }[];
        };
    };
}
