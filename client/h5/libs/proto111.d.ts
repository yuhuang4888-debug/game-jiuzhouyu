/** 秘籍
 */
declare interface ProtoFmtInfo {
    11100: {
        desc: "秘籍列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            command_list: {
                /**  功能名字 */
                func_name: string;
                /** 功能秘籍相关列表 */
                func_commands: {
                    /**  秘籍前缀 */
                    command: string;
                    /**  秘籍名字 */
                    command_name: string;
                    /** 参数说明 */
                    args_list: {
                        args: string;
                    }[];
                    /** 默认值(不为空就显示这个) */
                    default_list: {
                        args: string;
                    }[];
                }[];
            }[];
        };
    };
    11101: {
        desc: "执行秘籍";
        send: (
            number: 11101,
            fmt: "s",
            args: [
                /**组装好的秘籍*/
                command: string
            ]
        ) => never;
        sendFmt: "s";
        sendArgs: [
            /**组装好的秘籍*/
            command: string
        ];
        recv: null;
    };
}
