/** 变身系统
 */
declare interface ProtoFmtInfo {
    44000: {
        desc: "元神界面列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            god_list: {
                /** 1 出战  0 不出战 */
                is_battle: number;
                /** 元神id */
                god_id: number;
                /** 等级 */
                lv: number;
                /** 当前经验 */
                exp: number;
                /** 当前阶数 */
                grade: number;
                /** 星数 */
                star: number;
                /** 战力 */
                power: number;
                equip_list: {
                    /** 位置 */
                    pos: number;
                    /** 物品唯一id, */
                    goods_id: number;
                }[];
            }[];
        };
    };
    44001: {
        desc: "元神信息";
        send: (
            number: 44001,
            fmt: "i",
            args: [
                /**元神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**元神id*/
            god_id: number
        ];
        recv: {
            /** 1 出战  0 不出战 */
            is_battle: number;
            /** 元神id */
            god_id: number;
            /** 等级 */
            lv: number;
            /** 当前经验 */
            exp: number;
            /** 当前阶数 */
            grade: number;
            /** 星数 */
            star: number;
            /** 战力 */
            power: number;
            equip_list: {
                /** 位置 */
                pos: number;
                /** 物品唯一id, */
                goods_id: number;
            }[];
        };
    };
    44002: {
        desc: "激活元神";
        send: (
            number: 44002,
            fmt: "i",
            args: [
                /**元神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**元神id*/
            god_id: number
        ];
        recv: {
            /** 错误码 1为成功 */
            errcode: number;
            /** 战力 */
            power: number;
            /** 元神id */
            god_id: number;
        };
    };
    44003: {
        desc: "升级";
        send: (
            number: 44003,
            fmt: "i",
            args: [
                /**元神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**元神id*/
            god_id: number
        ];
        recv: {
            /** 错误码 1 成功 */
            errcode: number;
            /** 元神id */
            god_id: number;
            /** 等级 */
            lv: number;
            /** 当前经验 */
            exp: number;
            /** 战力 */
            power: number;
        };
    };
    44004: {
        desc: "升阶";
        send: (
            number: 44004,
            fmt: "i",
            args: [
                /**元神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**元神id*/
            god_id: number
        ];
        recv: {
            /** 错误码 1 成功 */
            errcode: number;
            /** 元神id */
            god_id: number;
            /** 阶数 */
            grade: number;
            /** 战力 */
            power: number;
        };
    };
    44005: {
        desc: "升星";
        send: (
            number: 44005,
            fmt: "i",
            args: [
                /**元神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**元神id*/
            god_id: number
        ];
        recv: {
            /** 错误码 1 成功 */
            errcode: number;
            /** 元神id */
            god_id: number;
            /** 星数 */
            star: number;
            /** 战力 */
            power: number;
        };
    };
    44006: {
        desc: "元神出战";
        send: (
            number: 44006,
            fmt: "ci",
            args: [
                /**孔位*/
                pos: number,
                /**元神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**孔位*/
            pos: number,
            /**元神id*/
            god_id: number
        ];
        recv: {
            /** 错误码 1 成功 */
            errcode: number;
            /** 元神id */
            god_id: number;
        };
    };
    44010: {
        desc: "变身cd信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** cd结束时间戳 */
            switch_cd: number;
            /** 变身结束时间戳 */
            end_time: number;
        };
    };
    44011: {
        desc: "切换变身";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 变身元神id */
            god_id: number;
        };
    };
    44012: {
        desc: "穿装备";
        send: (
            number: 44012,
            fmt: "li",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**降神id*/
                id: number
            ]
        ) => never;
        sendFmt: "li";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**降神id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    44013: {
        desc: "脱装备";
        send: (
            number: 44013,
            fmt: "ic",
            args: [
                /**降神id*/
                id: number,
                /**位置*/
                pos: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**降神id*/
            id: number,
            /**位置*/
            pos: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    44014: {
        desc: "快速合成";
        send: (
            number: 44014,
            fmt: "il",
            args: [
                /**合成规则id*/
                rule_id: number,
                /**身上物品id*/
                goods_id: number
            ]
        ) => never;
        sendFmt: "il";
        sendArgs: [
            /**合成规则id*/
            rule_id: number,
            /**身上物品id*/
            goods_id: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 合成规则id */
            rule_id: number;
            /** 合成的物品id */
            goods_id: number;
        };
    };
    44015: {
        desc: "未激活战力";
        send: (
            number: 44015,
            fmt: "i",
            args: [
                /**降神id*/
                god_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**降神id*/
            god_id: number
        ];
        recv: {
            /** 降神id */
            god_id: number;
            /** 降神期望战力 */
            power: number;
        };
    };
    44016: {
        desc: "智能合成";
        send: (number: 44016, fmt: any, args: [compose_list: any]) => never;
        sendFmt: any;
        sendArgs: [compose_list: any];
        recv: {
            /** 错误码 */
            code: number;
            /** 返回合成物品列表 */
            goods_list: {
                /** 物品主类型 */
                goods_type: number;
                /** 物品类型id */
                goods_type_id: number;
                /** 物品数量 */
                goods_num: number;
            }[];
        };
    };
    44017: {
        desc: "神格强化界面";
        send: (
            number: 44017,
            fmt: "c",
            args: [
                /**降神类型*/
                god_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**降神类型*/
            god_type: number
        ];
        recv: {
            /** 降神类型 */
            god_type: number;
            /** 当前降神类型等级 */
            current_lv: number;
            /** 当前经验值 */
            current_exp: number;
        };
    };
    44018: {
        desc: "神格强化";
        send: (
            number: 44018,
            fmt: "cAc",
            args: [
                /**降神类型*/
                god_type: number,
                goods_list: any,
                /**是否是分批发的*/
                is_divide: number
            ]
        ) => never;
        sendFmt: "cAc";
        sendArgs: [
            /**降神类型*/
            god_type: number,
            goods_list: any,
            /**是否是分批发的*/
            is_divide: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /**  参数 */
            args: string;
            /** 降神类型 */
            god_type: number;
            /** 当前降神类型等级 */
            current_lv: number;
            /** 当前经验值 */
            current_exp: number;
            /** 是否是分批发的 */
            is_divide: number;
        };
    };
}
