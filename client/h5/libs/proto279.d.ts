/** 永恒圣殿
 */
declare interface ProtoFmtInfo {
    27900: {
        desc: "永恒圣殿开启时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开启时间戳 */
            open_time: number;
            /** 进入截止时间 */
            enter_time: number;
            /** 结束时间戳 */
            end_time: number;
        };
    };
    27901: {
        desc: "永恒圣殿参与人数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 是否能进入高级场景 0否 1是 */
            can_enter_scene: number;
            join_list: {
                /** 场景id */
                scene: number;
                /** 本服参与人数 */
                self_server_num: number;
                /** 场景人数 */
                scene_num: number;
            }[];
        };
    };
    27902: {
        desc: "进入";
        send: (number: 27902, fmt: "h", args: [scene: number]) => never;
        sendFmt: "h";
        sendArgs: [scene: number];
        recv: {
            code: number;
        };
    };
    27903: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    27904: {
        desc: "怪物信息";
        send: (number: 27904, fmt: "h", args: [scene: number]) => never;
        sendFmt: "h";
        sendArgs: [scene: number];
        recv: {
            scene: number;
            mon: {
                mon_id: number;
                /** 怪物等级 */
                mon_lv: number;
                /** 圣殿怪物类型 */
                mon_type: number;
                /** 圣殿boss才会有归属服务器id */
                bl_server: number;
                /**  圣殿boss才会有归属服务器名字 */
                bl_server_name: string;
                /** 圣殿boss才会有归属服务器服数 */
                bl_server_num: number;
                /** 复活时间戳 */
                reborn_time: number;
            }[];
        };
    };
    27905: {
        desc: "怪物伤害统计";
        send: (
            number: 27905,
            fmt: "hi",
            args: [scene: number, mon_id: number]
        ) => never;
        sendFmt: "hi";
        sendArgs: [scene: number, mon_id: number];
        recv: {
            scene: number;
            mon_id: number;
            hurt_list: {
                /** 服务器id */
                server_id: number;
                /** 服务器数量 */
                server_num: number;
                /**  服务器名字 */
                server_name: string;
                /** 玩家id */
                player_id: number;
                /**  玩家名字 */
                player_name: string;
                /** 伤害百分比（0-10000） */
                damage: number;
            }[];
        };
    };
    27906: {
        desc: "死亡疲劳";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 死亡次数 */
            die_times: number;
            /** 死亡等待结束时间（可以免费复活） */
            time: number;
            /** buff结束时间 */
            die_time: number;
            /** 玩家回安全区时间（搬运尸体） */
            safe_time: number;
        };
    };
    27907: {
        desc: "boss刷新推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss刷新推送给场景所有玩家 */
            mon_id: number;
        };
    };
    27908: {
        desc: "boss死亡通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** bossid */
            mon_id: number;
            /** 复活时间戳 boss为0 */
            reborn_time: number;
            /** 归属服务器id boss才会有这个，其他都为0 */
            bl_server: number;
            /** 圣殿boss才会有归属服务器服数 */
            bl_server_num: number;
            /**  圣殿boss才会有归属服务器名字 */
            bl_server_name: string;
        };
    };
    27909: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
}
