/** 众生之门
 */
declare interface ProtoFmtInfo {
    24101: {
        desc: "众生之门状态(状态变更时会推送)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0未开放 1开放期间 */
            state: number;
            /** 结束时间 */
            end_time: number;
            /** 分服模式1248 */
            mod: number;
            /** 分区组id */
            group_id: number;
            /** 下一次活动开始时间 */
            next_start_time: number;
            server_list: {
                server_id: number;
                server_num: number;
                server_name: string;
                world_lv: number;
            }[];
            avg_lv: number;
        };
    };
    24102: {
        desc: "传送门信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            portal_list: {
                /** portal_id */
                portal_id: number;
                /** x坐标 */
                x: number;
                /** y坐标 */
                y: number;
            }[];
        };
    };
    24103: {
        desc: "进入传送门";
        send: (
            number: 24103,
            fmt: "l",
            args: [
                /**portal_id*/
                portal_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**portal_id*/
            portal_id: number
        ];
        recv: {
            code: number;
        };
    };
    24104: {
        desc: "进入众生之门场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    24105: {
        desc: "退出众生之门场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    24106: {
        desc: "销毁传送门";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** portal_id */
            portal_id: number;
        };
    };
    24107: {
        desc: "次数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 已协助次数 */
            assist_num: number;
            /** 已参战次数 */
            enter_num: number;
        };
    };
    24108: {
        desc: "进入玩法";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    24109: {
        desc: "获得招募副本Id";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 副本Id */
            dun_id: number;
        };
    };
}
