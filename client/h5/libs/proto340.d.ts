/** 邀请
 */
declare interface ProtoFmtInfo {
    34000: {
        desc: "错误码提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协议号 */
            pt: number;
            code: number;
            args: string;
        };
    };
    34001: {
        desc: "好友求助信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 领取状态##0:不可领取 1:已经领取 2:未领取 */
            get_status: number;
            /** 次数完全恢复时间戳 */
            recover_time: number;
            /** 今日领取次数 */
            daily_count: number;
            /** 总次数 */
            total_count: number;
            reward_list: {
                /** 奖励id */
                reward_id: number;
                /** 0:不可领取 1:已经领取 2:未领取 */
                status: number;
            }[];
        };
    };
    34002: {
        desc: "触发邀请";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    34003: {
        desc: "宝箱奖励领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 今日领取次数 */
            daily_count: number;
        };
    };
    34004: {
        desc: "奖励领取";
        send: (
            number: 34004,
            fmt: "cc",
            args: [
                /**奖励类型*/
                type: number,
                /**奖励id*/
                reward_id: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**奖励类型*/
            type: number,
            /**奖励id*/
            reward_id: number
        ];
        recv: {
            /** 奖励类型 */
            type: number;
            /** 奖励id */
            reward_id: number;
        };
    };
    34005: {
        desc: "帮助信息界面好友升级累计奖励走34004";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 达到5级的玩家数量 */
            count: number;
            reward_list: {
                /** 奖励id */
                reward_id: number;
                /** 0:不可领取 1:已经领取 2:未领取 */
                status: number;
            }[];
            pos_list: {
                /** 被邀请者id */
                invitee_id: number;
                /** 位置 */
                pos: number;
                /**  被邀请者名字 */
                name: string;
                /** 被邀请者等级 */
                lv: number;
                /** 被邀请者性别 */
                career: number;
                /** 0:不可领取 1:已经领取 2:未领取 */
                status: number;
            }[];
        };
    };
    34006: {
        desc: "升级信息界面好友升级累计奖励走34004";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            pos_list: {
                /** 被邀请者id */
                invitee_id: number;
                /** 位置 */
                pos: number;
                /**  被邀请者名字 */
                name: string;
                /** 被邀请者等级 */
                lv: number;
                /** 被邀请者性别 */
                career: number;
                /** 0:不可领取 1:已经领取 2:未领取 */
                status: number;
            }[];
        };
    };
    34007: {
        desc: "等级奖励位置领取";
        send: (
            number: 34007,
            fmt: "hc",
            args: [
                /**等级*/
                lv: number,
                /**位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "hc";
        sendArgs: [
            /**等级*/
            lv: number,
            /**位置*/
            pos: number
        ];
        recv: {
            /** 等级 */
            lv: number;
            /** 位置 */
            pos: number;
        };
    };
    34008: {
        desc: "等级奖励一次性领取信息";
        send: (
            number: 34008,
            fmt: "h",
            args: [
                /**等级*/
                lv: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**等级*/
            lv: number
        ];
        recv: {
            /** 等级 */
            lv: number;
            /** 大于本等级的数量 */
            count: number;
            reward: any;
        };
    };
    34009: {
        desc: "等级奖励一次性领取";
        send: (
            number: 34009,
            fmt: "h",
            args: [
                /**等级*/
                lv: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**等级*/
            lv: number
        ];
        recv: {
            /** 等级 */
            lv: number;
            reward: any;
        };
    };
    34010: {
        desc: "红包领取信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            red_packet_list: {
                /** 被邀请者id */
                invitee_id: number;
                /**  被邀请者名字 */
                name: string;
                /** 剩余可领取元宝 */
                left_gold: number;
                /** 上次领取的元宝数 */
                last_get_gold: number;
            }[];
        };
    };
    34011: {
        desc: "红包领取";
        send: (
            number: 34011,
            fmt: "l",
            args: [
                /**被邀请者id*/
                invitee_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**被邀请者id*/
            invitee_id: number
        ];
        recv: {
            /** 被邀请者id */
            invitee_id: number;
            reward: any;
        };
    };
    34012: {
        desc: "邀请奖励信息";
        send: (
            number: 34012,
            fmt: "c",
            args: [
                /**奖励类型*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**奖励类型*/
            type: number
        ];
        recv: {
            /** 奖励类型 */
            type: number;
            reward_list: {
                /** 奖励id */
                reward_id: number;
                /** 0:不可领取 1:已经领取 2:未领取 */
                status: number;
            }[];
        };
    };
}
