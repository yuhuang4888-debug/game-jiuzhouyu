/** 跨服入侵信息
 */
declare interface ProtoFmtInfo {
    48000: {
        desc: "跨服入侵活动返回码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    48001: {
        desc: "跨服入侵服列表信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 掠夺次数 */
            cl_count: number;
            /** 喋血之力 */
            bloody: number;
            /** 星盾之力 */
            shield: number;
            slist: {
                /** 服务器id */
                server_id: number;
                /**  服务器名称 */
                server_name: string;
                /** 繁荣度 */
                score: number;
                /** 排名 */
                rank: number;
                /** 世界等级 */
                world_lv: number;
                /** 是否可以入侵0:否;1:是 */
                is_invasion: number;
                /** 是否特殊收益服0:否;1:是 */
                is_special: number;
                /** 稀有采集次数 */
                cl_count: number;
                /**  最强公会名字 */
                guild_name: string;
                /**  最强公会会长名字 */
                grname: string;
            }[];
        };
    };
    48002: {
        desc: "跨服入侵状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶段状态0:关闭 1:开启 2:双倍 */
            step: number;
            /** 开始时间 */
            start_time: number;
            /** 结束时间 */
            end_time: number;
        };
    };
    48003: {
        desc: "跨服入侵左边状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的采集次数 */
            cl_count: number;
            /** 喋血之力 */
            bloody: number;
            /** 星盾之力 */
            shield: number;
        };
    };
    48004: {
        desc: "进入跨服入侵活动";
        send: (
            number: 48004,
            fmt: "h",
            args: [
                /**要入侵或者防守的server_id*/
                target_server_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**要入侵或者防守的server_id*/
            target_server_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    48005: {
        desc: "退出跨服入侵活动";
        send: (
            number: 48005,
            fmt: "h",
            args: [
                /**退出入侵或退出防守的server_id*/
                target_server_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**退出入侵或退出防守的server_id*/
            target_server_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    48006: {
        desc: "跨服入侵服排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            rank: {
                /** 服务器id */
                server_id: number;
                /**  服务器名称 */
                server_name: string;
                /** 繁荣度 */
                score: number;
                /** 排名 */
                rank: number;
            }[];
        };
    };
    48007: {
        desc: "跨服入侵玩家排行榜";
        send: (
            number: 48007,
            fmt: "c",
            args: [
                /**1:喋血之力榜;2:星盾之力榜*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:喋血之力榜;2:星盾之力榜*/
            type: number
        ];
        recv: {
            /** 1:喋血之力榜;2:星盾之力榜 */
            type: number;
            /** 我的排名 */
            my_rank: number;
            rank: {
                /** 服务器id */
                server_id: number;
                /**  服务器名称 */
                server_name: string;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 排名 */
                rank: number;
                /** 喋血之力|星盾之力榜 */
                value: number;
            }[];
        };
    };
}
