/** 技能信息
 */
declare interface ProtoFmtInfo {
    21001: {
        desc: "职业升级技能";
        send: (
            number: 21001,
            fmt: "i",
            args: [
                /**技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**技能id*/
            skill_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 技能id */
            skill_id: number;
        };
    };
    21002: {
        desc: "玩家职业技能列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 技能等级 */
                skill_lv: number;
            }[];
        };
    };
    21003: {
        desc: "技能强化信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            sum_onekey_cost: any;
            onekey_cost: any;
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 强化 */
                stren: number;
            }[];
        };
    };
    21004: {
        desc: "技能强化";
        send: (number: 21004, fmt: "i", args: [skill_id: number]) => never;
        sendFmt: "i";
        sendArgs: [skill_id: number];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 技能id */
            skill_id: number;
        };
    };
    21005: {
        desc: "技能一键强化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            skill_list: {
                /** 技能id */
                skill_id: number;
                /** 强化 */
                stren: number;
            }[];
        };
    };
    21010: {
        desc: "天赋技能面板信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 未分配的天赋点 */
            less_point: number;
            talent_skills: {
                /** 技能类型:攻击5;防守6;通用7 */
                skill_type: number;
                /** 投入的天赋点 */
                point: number;
                skills: {
                    /** 技能id */
                    skill_id: number;
                    /** 技能等级 */
                    skill_lv: number;
                }[];
            }[];
        };
    };
    21011: {
        desc: "天赋技能升级";
        send: (
            number: 21011,
            fmt: "i",
            args: [
                /**学习的技能id*/
                skill_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**学习的技能id*/
            skill_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 技能id */
            skill_id: number;
            /** 技能lv */
            skill_lv: number;
            /** 剩余技能点 */
            less_point: number;
        };
    };
    21012: {
        desc: "天赋技能重置";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 所有的技能点 */
            all_point: number;
        };
    };
}
