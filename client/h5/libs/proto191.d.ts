/** 礼包推送
 */
declare interface ProtoFmtInfo {
    19101: {
        desc: "激活的礼包列表(简略信息，登陆请求，红点处理)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1:当前全部礼包 2:新加的礼包 3: 离线过期的(服务端登陆后推送) */
            type: number;
            gift_list: {
                gift_id: number;
                sub_id: number;
                title_name: string;
                gift_name: string;
                /** 礼包结束时间 */
                end_time: number;
                /**  礼包一些信息 */
                infos: string;
            }[];
        };
    };
    19102: {
        desc: "激活的礼包列表(详细信息)";
        send: (
            number: 19102,
            fmt: "hh",
            args: [gift_id: number, sub_id: number]
        ) => never;
        sendFmt: "hh";
        sendArgs: [gift_id: number, sub_id: number];
        recv: {
            gift_id: number;
            sub_id: number;
            gift_name: string;
            /** 礼包结束时间 */
            end_time: number;
            conditions: string;
            reward_list: {
                grade_id: number;
                grade_name: string;
                /** 购买次数 */
                buy_cnt: number;
                /** 购买时间 0(未购买) */
                buy_time: number;
                /** 奖励的配置信息 */
                rewards_conditions: string;
                /**  奖励列表 */
                rewards: string;
            }[];
        };
    };
    19103: {
        desc: "购买礼包";
        send: (
            number: 19103,
            fmt: "hhh",
            args: [gift_id: number, sub_id: number, grade_id: number]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [gift_id: number, sub_id: number, grade_id: number];
        recv: {
            /** 错误码 */
            code: number;
            gift_id: number;
            sub_id: number;
            grade_id: number;
            /** 购买次数 */
            buy_cnt: number;
        };
    };
    19104: {
        desc: "请求离线过期礼包";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
}
