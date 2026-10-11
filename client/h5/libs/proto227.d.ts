/** 竞榜活动
 */
declare interface ProtoFmtInfo {
    22700: {
        desc: "获取正在开启的活动";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 活动开启时间 单位秒 */
            start_time: number;
            /** 活动结束时间 单位秒 */
            end_time: number;
            /** 活动结束上榜时间 单位秒 */
            upon_end_time: number;
        };
    };
    22701: {
        desc: "界面信息";
        send: (
            number: 22701,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 活动是否开启(0否1是) */
            is_open: number;
            /** 玩家积分 */
            score: number;
            rank: number;
            /** 目标奖励Id */
            id: number;
            /** 1为可领取；2为已领取；3为未达条件 */
            got_type: number;
        };
    };
    22702: {
        desc: "榜单信息";
        send: (
            number: 22702,
            fmt: "hh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 玩家积分 */
            score: number;
            /** 自己排名 */
            rank: number;
            /** 自个阶段奖励Id */
            reward_id: number;
            rank_list: {
                /** 排名 */
                rank: number;
                server_id: number;
                role_id: number;
                role_name: string;
                /** 积分 */
                role_score: number;
            }[];
        };
    };
    22703: {
        desc: "昨日榜单信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 玩家积分 */
            score: number;
            /** 自己排名 */
            rank: number;
            /** 推送方式 0-玩家请求，1-服务端自行推送 */
            push_type: number;
            rank_list: {
                /** 排名 */
                rank: number;
                server_id: number;
                role_id: number;
                role_name: string;
                /** 积分 */
                role_score: number;
            }[];
        };
    };
    22704: {
        desc: "领取目标奖励";
        send: (
            number: 22704,
            fmt: "hhh",
            args: [
                /**主类型*/
                type: number,
                /**次类型*/
                subtype: number,
                /**奖励id*/
                reward_id: number
            ]
        ) => never;
        sendFmt: "hhh";
        sendArgs: [
            /**主类型*/
            type: number,
            /**次类型*/
            subtype: number,
            /**奖励id*/
            reward_id: number
        ];
        recv: {
            /** 主类型 */
            type: number;
            /** 次类型 */
            subtype: number;
            /** 奖励id */
            reward_id: number;
            /** 错误码 */
            error_code: number;
        };
    };
    22705: {
        desc: "冲榜排名变化提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主类型 */
            rank_type: number;
            /** 子类型 */
            rank_subtype: number;
            /** 变化类型：1. 则显示玩家提高xx分可领取目标奖励 2. 若与排名积分比较接近, 则每次显示玩家提升xx分可超过下一阶段最后一名, 3. 当排名被超过时，显示\冲榜排名已被其他玩家超越\ */
            type: number;
            /** 下一阶段排名 */
            rank: number;
            /** 需要提升的分数 */
            value: number;
        };
    };
    22706: {
        desc: "第一名发生变化时服务端主动推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 主类型 */
            rank_type: number;
            /** 子类型 */
            rank_subtype: number;
            /** 服务器ID */
            server_id: number;
            /** 角色ID */
            role_id: number;
            /**  角色名字 */
            role_name: string;
            /** 积分 */
            role_score: number;
        };
    };
}
