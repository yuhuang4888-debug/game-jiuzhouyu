/** 精灵信息
 */
declare interface ProtoFmtInfo {
    14800: {
        desc: "错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            res: number;
        };
    };
    14801: {
        desc: "精灵信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            res: number;
            /** 当前使用的精灵id */
            fairy_now: number;
            fairy_figure: {
                /** 精灵Id */
                fairy_id: number;
                /** 阶级 */
                stage: number;
                /** 等级 */
                level: number;
            }[];
        };
    };
    14802: {
        desc: "单个精灵信息";
        send: (
            number: 14802,
            fmt: "l",
            args: [
                /**精灵Id*/
                fairy_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**精灵Id*/
            fairy_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 精灵Id */
            fairy_id: number;
            /** 阶级 */
            stage: number;
            /** 等级 */
            level: number;
            /** 等级经验 */
            exp: number;
            /** 战力 */
            combat: number;
            skill_list: {
                /** 技能 */
                skill: number;
            }[];
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
        };
    };
    14803: {
        desc: "精灵升阶";
        send: (
            number: 14803,
            fmt: "l",
            args: [
                /**精灵Id*/
                fairy_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**精灵Id*/
            fairy_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 精灵Id */
            fairy_id: number;
            /** 阶数 */
            stage: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
        };
    };
    14804: {
        desc: "精灵升级";
        send: (
            number: 14804,
            fmt: "l",
            args: [
                /**精灵Id*/
                fairy_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**精灵Id*/
            fairy_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 精灵Id */
            fairy_id: number;
            /** 级数 */
            level: number;
            /** 经验值 */
            exp: number;
            attr_list: {
                /** 属性类型 */
                attr_id: number;
                /** 属性值 */
                attr_val: number;
            }[];
        };
    };
    14805: {
        desc: "精灵幻化";
        send: (
            number: 14805,
            fmt: "l",
            args: [
                /**精灵Id*/
                fairy_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**精灵Id*/
            fairy_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 已经幻化的精灵Id */
            fairy_now: number;
        };
    };
    14806: {
        desc: "场景广播";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 玩家ID */
            role_id: number;
            /** 玩家当前精灵形象Id */
            battle_id: number;
        };
    };
    14807: {
        desc: "单个未激活精灵信息";
        send: (
            number: 14807,
            fmt: "l",
            args: [
                /**精灵Id*/
                fairy_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**精灵Id*/
            fairy_id: number
        ];
        recv: {
            /** 返回码 */
            res: number;
            /** 精灵Id */
            fairy_id: number;
            /** 战力 */
            combat: number;
        };
    };
}
