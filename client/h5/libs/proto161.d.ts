/** 翅膀信息
 */
declare interface ProtoFmtInfo {
    16100: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    16101: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 玩家当前翅膀形象 */
            figure_id: number;
        };
    };
    16102: {
        desc: "翅膀信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 翅膀等级 */
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
            /** 翅膀战力 */
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
    16103: {
        desc: "幻化翅膀";
        send: (
            number: 16103,
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
    16104: {
        desc: "显示翅膀";
        send: (
            number: 16104,
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
    16105: {
        desc: "翅膀升级";
        send: (
            number: 16105,
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
    16106: {
        desc: "翅膀化形升星";
        send: (
            number: 16106,
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
    16107: {
        desc: "化形界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 当前幻化形象id */
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
    16108: {
        desc: "化形激活";
        send: (
            number: 16108,
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
    16109: {
        desc: "化形形象详细信息";
        send: (
            number: 16109,
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
    16110: {
        desc: "使用仙羽";
        send: (
            number: 16110,
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
    16111: {
        desc: "仙羽使用次数";
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
