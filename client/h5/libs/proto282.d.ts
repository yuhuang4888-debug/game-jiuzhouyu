/** 角色界面信息
 */
declare interface ProtoFmtInfo {
    28202: {
        desc: "伙伴信息列表";
        send: (
            number: 28202,
            fmt: "l",
            args: [
                /**玩家id*/
                role_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**玩家id*/
            role_id: number
        ];
        recv: {
            partners: {
                /** 伙伴唯一Id */
                id: number;
                /** 伙伴id */
                partnerid: number;
                /** 等级 */
                lv: number;
                /** 出战状态 */
                state: number;
                /** 出战列表中的位置 */
                pos: number;
                /** 战力 */
                combat: number;
                /** 奇才 */
                prodigy: number;
                /** 武器激活状态 */
                weapon: number;
            }[];
        };
    };
    28203: {
        desc: "获取伙伴基础信息";
        send: (
            number: 28203,
            fmt: "ll",
            args: [
                /**玩家id*/
                role_id: number,
                /**伙伴唯一id*/
                id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**伙伴唯一id*/
            id: number
        ];
        recv: {
            /** 返回码，1成功 */
            code: number;
            /** 伙伴唯一id */
            id: number;
            /** 伙伴id */
            partnerid: number;
            /** 等级 */
            lv: number;
            /** 经验值 */
            exp: number;
            /** 最大经验值 */
            maxexp: number;
            /** 突破状态 0 不可突破 1 可突破 */
            break_st: number;
            base_attr: {
                /** 属性类型 体质敏捷 */
                type: number;
                /** 当前值 */
                curval: number;
                /** 上限值 */
                uppval: number;
                /** 属性品质 */
                quality: number;
            }[];
            skill: {
                /** 技能书id */
                sk_book: number;
                /** 技能id */
                sk_id: number;
                /** 技能等级 */
                sk_lv: number;
                /** 技能位置 9 护主 10 天赋 */
                sk_pos: number;
            }[];
            /** 伙伴专属武器id */
            weapon: number;
            /** 战力 */
            combat: number;
            /** 奇才 */
            prodigy: number;
        };
    };
    28204: {
        desc: "获取伙伴二级属性信息";
        send: (
            number: 28204,
            fmt: "ll",
            args: [
                /**玩家id*/
                role_id: number,
                /**id*/
                id: number
            ]
        ) => never;
        sendFmt: "ll";
        sendArgs: [
            /**玩家id*/
            role_id: number,
            /**id*/
            id: number
        ];
        recv: {
            /** 返回码 1成功 */
            code: number;
            /** id */
            id: number;
            /** 属性信息 */
            attr: any;
        };
    };
}
