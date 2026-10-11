/** 游戏信息
 */
declare interface ProtoFmtInfo {
    10200: {
        desc: "获取合服分区分组";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开服天数 */
            open_day: number;
            /** 跨服平均世界等级 */
            avg_lv: number;
            list: {
                /** 功能ID */
                module_id: number;
                /** 1本服 2 4 8 */
                mod: number;
                server_infos: {
                    server_id: number;
                    server_num: number;
                    server_name: string;
                    world_lv: number;
                }[];
            }[];
        };
    };
    10201: {
        desc: "获取开服合服时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开服时间(不考虑时间偏移(目前项目没有),就是开服当天凌晨) */
            open_time: number;
            /** 合服时间(合服的准确时间,合服记录,不一定是零点) */
            merge_time: number;
            /** 合服的开始时间(不考虑时间偏移(目前项目没有),就是合服当天凌晨) */
            merge_start_time: number;
            /** 合服次数 */
            merge_count: number;
            /** 服务器时间 */
            server_time: number;
        };
    };
    10202: {
        desc: "系统开关设置列表";
        send: (
            number: 10202,
            fmt: "c",
            args: [
                /**设置大类*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**设置大类*/
            type: number
        ];
        recv: {
            /** 设置大类 */
            type: number;
            setting_list: {
                /** 设置小类 */
                subtype: number;
                /** 开关 1:开 0:关 */
                is_open: number;
            }[];
        };
    };
    10203: {
        desc: "系统开关设置";
        send: (number: 10203, fmt: any, args: [setting_list: any]) => never;
        sendFmt: any;
        sendArgs: [setting_list: any];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    10204: {
        desc: "上传客户端版本号";
        send: (
            number: 10204,
            fmt: "l",
            args: [
                /**客户端的版本号*/
                client_ver: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**客户端的版本号*/
            client_ver: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
        };
    };
    10205: {
        desc: "通用错误提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            error_code: number;
            /**  参数 */
            args: string;
        };
    };
    10206: {
        desc: "通用错误提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协议 */
            pt: number;
            /** 错误码 */
            error_code: number;
            /**  参数 */
            args: string;
        };
    };
    10207: {
        desc: "通知处理";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 类型 */
            type: number;
        };
    };
    10208: {
        desc: "订阅信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 订阅类型##0:无;1:深海订阅 */
            subscribe_type: number;
        };
    };
    10209: {
        desc: "设置订阅";
        send: (
            number: 10209,
            fmt: "c",
            args: [
                /**订阅类型##0:无;1:深海订阅*/
                subscribe_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**订阅类型##0:无;1:深海订阅*/
            subscribe_type: number
        ];
        recv: null;
    };
    10210: {
        desc: "脱离卡死";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    10211: {
        desc: "功能弹窗";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 唯一id */
            uid: number;
        };
    };
}
