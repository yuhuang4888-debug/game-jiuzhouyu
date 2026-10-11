/** 法宝信息
 */
declare interface ProtoFmtInfo {
    16800: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    16801: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 玩家当前法宝形象 */
            figure_id: number;
        };
    };
    16802: {
        desc: "法宝信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 法宝等级 */
            lv: number;
            /** 当前经验 */
            exp: number;
            /** 当前选择幻化形象 */
            illusion_id: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
            /** 法宝战力 */
            combat: number;
            /** 0: 隐藏 1: 显示 */
            display_status: number;
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
            }[];
        };
    };
    16803: {
        desc: "幻化法宝";
        send: (
            number: 16803,
            fmt: "i",
            args: [
                /**化形Id*/
                illusion_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**化形Id*/
            illusion_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 化形Id */
            illusion_id: number;
        };
    };
    16804: {
        desc: "显示法宝";
        send: (
            number: 16804,
            fmt: "c",
            args: [
                /**0: 隐藏  1：显示*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0: 隐藏  1：显示*/
            type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 0: 隐藏  1：显示 */
            type: number;
        };
    };
    16805: {
        desc: "法宝升级";
        send: (
            number: 16805,
            fmt: "ic",
            args: [
                /**物品类型id*/
                type_id: number,
                /**1: 一键升级 0：使用一个升级*/
                auto: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**物品类型id*/
            type_id: number,
            /**1: 一键升级 0：使用一个升级*/
            auto: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 等级 */
            lv: number;
            /** 当前经验值 */
            exp: number;
            /** 增加的经验值 */
            exp_plus: number;
        };
    };
    16806: {
        desc: "法宝化形升星";
        send: (
            number: 16806,
            fmt: "i",
            args: [
                /**化形id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**化形id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 星数 */
            star: number;
            /** 化形id */
            id: number;
        };
    };
    16807: {
        desc: "化形界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 当前h幻化形象id */
            figure_id: number;
            /** 已激活的幻形形象列表 */
            figure_list: {
                /** 形象id */
                id: number;
                /** 星数 */
                star: number;
            }[];
        };
    };
    16808: {
        desc: "化形激活";
        send: (
            number: 16808,
            fmt: "i",
            args: [
                /**化形id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**化形id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 化形id */
            id: number;
        };
    };
    16809: {
        desc: "化形形象详细信息";
        send: (
            number: 16809,
            fmt: "i",
            args: [
                /**化形id*/
                id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**化形id*/
            id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 化形id */
            id: number;
            /** 星数 */
            star: number;
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
    16810: {
        desc: "使用仙羽";
        send: (
            number: 16810,
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
            /** 错误码 */
            errcode: number;
            /** 物品类型id */
            type_id: number;
        };
    };
    16811: {
        desc: "魂珠使用次数";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 道具使用次数 */
            counter_list: {
                /** 物品id */
                goods_id: number;
                /** 使用次数 */
                times: number;
                /** 次数限制 */
                times_lim: number;
            }[];
        };
    };
}
