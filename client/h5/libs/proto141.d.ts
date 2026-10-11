/** 背饰
 */
declare interface ProtoFmtInfo {
    14100: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 外形类型 9 背饰状态 */
            type_id: number;
            /** 玩家ID */
            role_id: number;
            /** 0: 非骑乘 1: 骑乘 */
            is_ride: number;
            /** 玩家当前形象Id */
            figure_id: number;
            /** 玩家速度 */
            speed: number;
        };
    };
    14101: {
        desc: "背饰列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            back_decoration_list: {
                back_decoration_id: number;
                /** 阶数 */
                stage: number;
                /** 0 没幻化 1 幻化中 */
                state: number;
            }[];
        };
    };
    14102: {
        desc: "背饰详情";
        send: (
            number: 14102,
            fmt: "i",
            args: [
                /**背饰id*/
                back_decoration_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**背饰id*/
            back_decoration_id: number
        ];
        recv: {
            code: number;
            /** 背饰id */
            back_decoration_id: number;
            /** 阶数 */
            stage: number;
            /** 0 没幻化 1 幻化中 */
            state: number;
            /** 幻化中的figureId */
            figure_id: number;
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 技能等级 */
                skill_lv: number;
            }[];
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
    14103: {
        desc: "幻化";
        send: (
            number: 14103,
            fmt: "ic",
            args: [
                /**背饰id*/
                back_decoration_id: number,
                /**背饰阶数*/
                stage: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**背饰id*/
            back_decoration_id: number,
            /**背饰阶数*/
            stage: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 背饰id */
            back_decoration_id: number;
            /** 背饰阶数 */
            stage: number;
        };
    };
    14104: {
        desc: "激活";
        send: (
            number: 14104,
            fmt: "i",
            args: [
                /**背饰id*/
                back_decoration_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**背饰id*/
            back_decoration_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 背饰id */
            back_decoration_id: number;
        };
    };
    14105: {
        desc: "升阶";
        send: (
            number: 14105,
            fmt: "i",
            args: [
                /**背饰id*/
                back_decoration_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**背饰id*/
            back_decoration_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 形象id */
            back_decoration_id: number;
            /** 阶数 */
            stage: number;
            /** 0 没幻化 1 幻化中 */
            state: number;
            /** 解锁技能列表 */
            skill_list: {
                /** 技能id */
                skill_id: number;
            }[];
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
    14106: {
        desc: "未激活的背饰战力";
        send: (
            number: 14106,
            fmt: "i",
            args: [
                /**背饰id*/
                back_decoration_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**背饰id*/
            back_decoration_id: number
        ];
        recv: {
            /** 背饰id */
            back_decoration_id: number;
            /** 真实战力 */
            power: number;
        };
    };
}
