/** 奥秘
 */
declare interface ProtoFmtInfo {
    17800: {
        desc: "错误码提示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协议号 */
            pt: number;
            code: number;
            args: string;
        };
    };
    17801: {
        desc: "奥秘信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            page_list: {
                /** 页 */
                page_id: number;
                glyph_list: {
                    /** 奥秘id */
                    glyph_id: number;
                    /** 星数 */
                    star: number;
                    /** 等级 */
                    lv: number;
                }[];
                /** 总战力 */
                combot_power: number;
                /** 技能激活星数 */
                skill_active_star: number;
                /** 凝练属性 */
                wash_list: {
                    /** 属性id */
                    attr_id: number;
                    /** 属性值 */
                    num: number;
                }[];
                /** 特殊凝练次数 */
                sp_wash_count: number;
            }[];
            enchant_list: {
                /** 附魔id */
                enchant_id: number;
                /** 次数 */
                count: number;
            }[];
        };
    };
    17802: {
        desc: "升星首次激活:会变成一星一级";
        send: (
            number: 17802,
            fmt: "h",
            args: [
                /**奥秘id*/
                glyph_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**奥秘id*/
            glyph_id: number
        ];
        recv: {
            /** 奥秘id */
            glyph_id: number;
            /** 总战力 */
            combot_power: number;
        };
    };
    17803: {
        desc: "升级星数为0:无法升级";
        send: (
            number: 17803,
            fmt: "h",
            args: [
                /**奥秘id*/
                glyph_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**奥秘id*/
            glyph_id: number
        ];
        recv: {
            /** 奥秘id */
            glyph_id: number;
            /** 总战力 */
            combot_power: number;
        };
    };
    17804: {
        desc: "奥秘技能升级";
        send: (
            number: 17804,
            fmt: "h",
            args: [
                /**页*/
                page_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**页*/
            page_id: number
        ];
        recv: {
            /** 页 */
            page_id: number;
            /** 技能激活星数 */
            skill_active_star: number;
            /** 总战力 */
            combot_power: number;
        };
    };
    17805: {
        desc: "奥秘凝练";
        send: (
            number: 17805,
            fmt: "h",
            args: [
                /**页*/
                page_id: number
            ]
        ) => never;
        sendFmt: "h";
        sendArgs: [
            /**页*/
            page_id: number
        ];
        recv: {
            /** 页 */
            page_id: number;
            /** 凝练属性 */
            wash_list: {
                /** 属性id */
                attr_id: number;
                /** 属性值 */
                num: number;
            }[];
            /** 特殊凝练次数 */
            sp_wash_count: number;
            /** 总战力 */
            combot_power: number;
        };
    };
    17806: {
        desc: "奥秘附魔";
        send: (
            number: 17806,
            fmt: "c",
            args: [
                /**附魔id*/
                enchant_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**附魔id*/
            enchant_id: number
        ];
        recv: {
            /** 附魔id */
            enchant_id: number;
            /** 次数 */
            count: number;
        };
    };
}
