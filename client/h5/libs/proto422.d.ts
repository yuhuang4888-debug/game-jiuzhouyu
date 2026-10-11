/** 星图
 */
declare interface ProtoFmtInfo {
    42200: {
        desc: "获取星图信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 星图id */
            star_map_id: number;
            /** 拥有的星力值 */
            star_power: number;
            attr: {
                /** 属性类型 */
                attr_type: number;
                /** 属性增加值 */
                attr_value: number;
            }[];
        };
    };
    42201: {
        desc: "点亮星点注：成功后主动推42200";
        send: (
            number: 42201,
            fmt: "i",
            args: [
                /**星点id*/
                star_map_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**星点id*/
            star_map_id: number
        ];
        recv: {
            /** 返回码 1-成功 */
            res_code: number;
        };
    };
}
