/** 伙伴出战
 */
declare interface ProtoFmtInfo {
    20101: {
        desc: "伙伴出战列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前的组别 */
            group_id: number;
            /** 下次能选择的时间戳 */
            next_choice_time: number;
            partner_list: {
                /** 伙伴怪物唯一id */
                auto_id: number;
                /** 伙伴配置id */
                partner_id: number;
                /** 位置 */
                pos: number;
                /** 伙伴等级 */
                lv: number;
                /** 血量 */
                hp: number;
                /** 血量上限 */
                hp_lim: number;
            }[];
        };
    };
    20102: {
        desc: "伙伴组切换";
        send: (
            number: 20102,
            fmt: "c",
            args: [
                /**1:第一组 2:第二组*/
                group_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1:第一组 2:第二组*/
            group_id: number
        ];
        recv: {
            /** 错误码 */
            error_code: number;
            /** 1:第一组 2:第二组 */
            group_id: number;
            /** 下次能选择的时间戳 */
            next_choice_time: number;
        };
    };
}
