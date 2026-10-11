/** 圣灵信息
 */
declare interface ProtoFmtInfo {
    60600: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /**  参数 */
            args: string;
        };
    };
    60601: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 玩家圣灵形象 0: 表示没有 */
            figure_id: number;
            /** 0: 隐藏 1: 显示 */
            display: number;
        };
    };
    60602: {
        desc: "圣灵信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 出战圣灵id */
            fight_id: number;
            /** 出战幻形id */
            fight_illu_id: number;
            ghost_list: {
                /** 已激活圣灵Id */
                id: number;
                /** 阶数 */
                stage: number;
                /** 觉醒等级 */
                lv: number;
            }[];
            illu_list: {
                /** 已激活的幻形id */
                illu_id: number;
            }[];
            display: number;
        };
    };
    60603: {
        desc: "圣灵详细信息";
        send: (
            number: 60603,
            fmt: "i",
            args: [
                /**圣灵Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**圣灵Id*/
            id: number
        ];
        recv: {
            /** 圣灵Id */
            id: number;
            /** 阶级 */
            stage: number;
            /** 经验值 */
            exp: number;
            /** 觉醒等级 */
            lv: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 战力 */
            combat: number;
        };
    };
    60604: {
        desc: "幻形详细信息";
        send: (
            number: 60604,
            fmt: "i",
            args: [
                /**幻形Id*/
                illu_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**幻形Id*/
            illu_id: number
        ];
        recv: {
            /** 幻形Id */
            illu_id: number;
            /** 生效时间戳 */
            end_time: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 战力 */
            combat: number;
        };
    };
    60605: {
        desc: "遗迹充能次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 道具使用次数 */
            counter_list: {
                /** 物品id */
                goods_id: number;
                /** 遗迹id */
                id: number;
                /** 使用次数 */
                count: number;
                /** 次数限制 */
                count_lim: number;
            }[];
        };
    };
    60606: {
        desc: "圣灵激活";
        send: (
            number: 60606,
            fmt: "i",
            args: [
                /**圣灵Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**圣灵Id*/
            id: number
        ];
        recv: {
            /** 圣灵Id */
            id: number;
        };
    };
    60607: {
        desc: "圣灵升阶";
        send: (
            number: 60607,
            fmt: "ii",
            args: [
                /**圣灵Id*/
                id: number,
                /**物品类型id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**圣灵Id*/
            id: number,
            /**物品类型id*/
            type_id: number
        ];
        recv: {
            /** 圣灵Id */
            id: number;
            /** 阶数 */
            stage: number;
            /** 经验值 */
            exp: number;
        };
    };
    60608: {
        desc: "圣灵觉醒";
        send: (
            number: 60608,
            fmt: "i",
            args: [
                /**圣灵Id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**圣灵Id*/
            id: number
        ];
        recv: {
            /** 圣灵Id */
            id: number;
            /** 觉醒等级 */
            lv: number;
        };
    };
    60609: {
        desc: "圣灵幻形激活";
        send: (
            number: 60609,
            fmt: "i",
            args: [
                /**幻形Id*/
                illu_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**幻形Id*/
            illu_id: number
        ];
        recv: {
            /** 幻形Id */
            illu_id: number;
        };
    };
    60610: {
        desc: "圣灵幻形失效";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 幻形Id */
            illu_id: number;
        };
    };
    60611: {
        desc: "圣灵出战";
        send: (
            number: 60611,
            fmt: "ci",
            args: [
                /**1圣灵出战|2幻形出战*/
                type: number,
                /**圣灵id|幻形id*/
                id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**1圣灵出战|2幻形出战*/
            type: number,
            /**圣灵id|幻形id*/
            id: number
        ];
        recv: {
            /** 1圣灵出战|2幻形出战 */
            type: number;
            /** 圣灵id|幻形id */
            id: number;
        };
    };
    60612: {
        desc: "遗迹充能";
        send: (
            number: 60612,
            fmt: "i",
            args: [
                /**物品类型id*/
                type_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**物品类型id*/
            type_id: number
        ];
        recv: {
            /** 物品类型id */
            type_id: number;
        };
    };
    60613: {
        desc: "隐藏/显示";
        send: (
            number: 60613,
            fmt: "c",
            args: [
                /**0: 隐藏 1: 显示*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0: 隐藏 1: 显示*/
            type: number
        ];
        recv: {
            /** 0: 隐藏 1: 显示 */
            type: number;
        };
    };
    60614: {
        desc: "结界上阵信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            bound_list: {
                /** 位置 */
                location: number;
                /** 圣灵id */
                id: number;
            }[];
        };
    };
    60615: {
        desc: "结界上阵";
        send: (
            number: 60615,
            fmt: "ci",
            args: [location: number, id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [location: number, id: number];
        recv: {
            /** 位置 */
            location: number;
            /** 圣灵id */
            id: number;
        };
    };
    60616: {
        desc: "结界下阵";
        send: (
            number: 60616,
            fmt: "ci",
            args: [location: number, id: number]
        ) => never;
        sendFmt: "ci";
        sendArgs: [location: number, id: number];
        recv: {
            /** 位置 */
            location: number;
            /** 圣灵id */
            id: number;
        };
    };
}
