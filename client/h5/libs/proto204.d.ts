/** 时空裂缝
 */
declare interface ProtoFmtInfo {
    20400: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    20401: {
        desc: "主界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前自己的争夺值 */
            my_value: number;
            /** 当前自己服所有据点加起来的争夺值 */
            my_server_value: number;
            /** 占领情况 */
            castle_list: {
                /** 据点id */
                castle_id: number;
                base_server_num: number;
                /** 占领需要的争夺值 */
                need_value: number;
                /** 当前占领的服务器 */
                server_num: number;
                server_name: string;
                server_list: {
                    server_num: number;
                    server_name: string;
                    /** 注入的争夺值 */
                    value: number;
                }[];
                role_list: {
                    server_num2: number;
                    role_name: string;
                    /** 争夺值 */
                    value2: number;
                    /** 0 没有驻扎  1 驻扎 */
                    is_occupy: number;
                }[];
                /** 当前本服驻扎人数 */
                role_num: number;
                /** 本服提供过争夺值的人数 */
                provide_num: number;
            }[];
        };
    };
    20402: {
        desc: "单个据点界面信息有争夺值的据点变更主动推";
        send: (
            number: 20402,
            fmt: "h",
            args: [
                /**据点id*/
                castle_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**据点id*/
            castle_id: number
        ];
        recv: {
            /** 据点id */
            castle_id: number;
            base_server_num: number;
            /** 占领需要的争夺值 */
            need_value: number;
            /** 当前占领的服务器 */
            server_num: number;
            server_name: string;
            server_list: {
                /** 服务器 */
                server_num: number;
                server_name: string;
                /** 注入的争夺值 */
                value: number;
            }[];
            role_list: {
                server_num2: number;
                role_name: string;
                /** 争夺值 */
                value2: number;
                /** 0 没有驻扎  1 驻扎 */
                is_occupy: number;
            }[];
            /** 当前本服驻扎人数 */
            role_num: number;
            /** 本服提供过争夺值的人数 */
            provide_num: number;
        };
    };
    20403: {
        desc: "驻扎成功后推送01协议";
        send: (
            number: 20403,
            fmt: "h",
            args: [
                /**据点id*/
                castle_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**据点id*/
            castle_id: number
        ];
        recv: {
            /** 操作码 */
            code: number;
        };
    };
    20404: {
        desc: "每日争夺";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            act_list: {
                /** 模块 */
                mod: number;
                /** 子模块 */
                sub_mod: number;
                /** 争夺值 */
                value: number;
            }[];
        };
    };
    20405: {
        desc: "每日争夺奖励争夺值有变动主动推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当天累计争夺值 */
            value: number;
            /** 总争夺值 */
            all_value: number;
            act_list: {
                /** 阶段 */
                stage: number;
                /** 0 不能领取  1 可以领取  2 已经领取 */
                status: number;
            }[];
        };
    };
    20406: {
        desc: "每日争夺奖励成功后推送05协议";
        send: (number: 20406, fmt: "c", args: [stage: number]) => never;
        sendFmt: "c";
        sendArgs: [stage: number];
        recv: {
            stage: number;
            /** 操作码 */
            code: number;
        };
    };
    20407: {
        desc: "赛季目标";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            act_list: {
                /** 任务id */
                goal_id: number;
                /** 任务数值 */
                value: number;
                /** 0 不能领取  1 可以领取  2 已经领取 */
                status: number;
            }[];
        };
    };
    20408: {
        desc: "领取赛季奖励";
        send: (
            number: 20408,
            fmt: "h",
            args: [
                /**任务id*/
                goal_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**任务id*/
            goal_id: number
        ];
        recv: {
            /** 任务id */
            goal_id: number;
            code: number;
        };
    };
    20409: {
        desc: "个人排名";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_list: {
                server_num: number;
                role_id: number;
                role_name: string;
                /** 争夺值 */
                value: number;
            }[];
        };
    };
    20410: {
        desc: "当前据点";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 操作码 */
            castle_id: number;
        };
    };
    20411: {
        desc: "世界信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 未开启  1 开启 */
            status: number;
            server_list: {
                server_num: number;
                server_name: string;
                lv: number;
            }[];
        };
    };
}
