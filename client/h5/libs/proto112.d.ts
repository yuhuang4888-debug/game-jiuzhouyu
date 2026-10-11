/** 个性装扮
 */
declare interface ProtoFmtInfo {
    11200: {
        desc: "获取装扮列表";
        send: (
            number: 11200,
            fmt: "c",
            args: [
                /**装扮类型：1气泡 2相框*/
                dress_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**装扮类型：1气泡 2相框*/
            dress_type: number
        ];
        recv: {
            /** 装扮类型：1气泡 2相框 */
            dress_type: number;
            /** 正在使用装扮id  注:如果没有正在使用的，本字段值为0 */
            use_dress_id: number;
            /** 激活列表 */
            enable_list: {
                /** 装扮id */
                dress_id: number;
                /** 装扮等级 */
                dress_lv: number;
                /** 当前战力 */
                cur_power: number;
                /** 下一级战力 */
                next_power: number;
            }[];
        };
    };
    11201: {
        desc: "激活装扮";
        send: (
            number: 11201,
            fmt: "ci",
            args: [
                /**装扮类型：1气泡 2相框*/
                dress_type: number,
                /**装扮id*/
                dress_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**装扮类型：1气泡 2相框*/
            dress_type: number,
            /**装扮id*/
            dress_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装扮类型：1气泡 2相框 */
            dress_type: number;
            /** 装扮id */
            dress_id: number;
            /** 装扮等级 */
            dress_lv: number;
            /** 当前战力 */
            cur_power: number;
            /** 下一级战力 */
            next_power: number;
        };
    };
    11202: {
        desc: "使用装扮";
        send: (
            number: 11202,
            fmt: "ci",
            args: [
                /**装扮类型：1气泡 2相框*/
                dress_type: number,
                /**装扮id*/
                dress_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**装扮类型：1气泡 2相框*/
            dress_type: number,
            /**装扮id*/
            dress_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装扮类型：1气泡 2相框 */
            dress_type: number;
            /** 装扮id */
            dress_id: number;
        };
    };
    11203: {
        desc: "卸下装扮";
        send: (
            number: 11203,
            fmt: "ci",
            args: [
                /**装扮类型：1气泡 2相框*/
                dress_type: number,
                /**装扮id*/
                dress_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**装扮类型：1气泡 2相框*/
            dress_type: number,
            /**装扮id*/
            dress_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 装扮类型：1气泡 2相框 */
            dress_type: number;
            /** 装扮id */
            dress_id: number;
        };
    };
    11204: {
        desc: "装扮列表广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家id */
            role_id: number;
            /** 装扮列表 */
            dress_list: {
                /** 装扮类型：1气泡 2相框 */
                dress_type: number;
                /** 装扮等级 */
                dress_id: number;
            }[];
        };
    };
}
