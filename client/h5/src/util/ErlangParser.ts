import { SpecialCharKey } from "../common/SpecialCharKey";
import { GameError } from "./GameError";
export class ErArray {
    item_list;
    public constructor() {
        this.item_list = [];
    }
    public Release() {
        this.item_list.length = 0;
    }
}
export class ErListItem {
    data;
    item_type = ErlangParser.ErListItemType.Unknown;
    public constructor() {
    }
    public InitAsType(type) {
        this.item_type = type;
        switch (type) {
            case ErlangParser.ErListItemType.DataType:
                this.data = null;
                break;
            case ErlangParser.ErListItemType.Obj:
            case ErlangParser.ErListItemType.Array:
                this.data = new ErArray();
                break;
        }
    }
}
export class ErlangParser {
    static Instance: ErlangParser;
    static ErListItemType = {
        Unknown: 1,
        DataType: 2,
        Obj: 3,
        Array: 4,
    };
    buf: String;
    buf_len;
    cur_pos;
    main_list;
    identityCharParttern = /[\w\.\-\u4E00-\u9FA5]/
    public constructor() {
        this.cur_pos = this.buf_len = 0;
        this.main_list = new ErArray();
    }
    public static GetInstance() {
        if (!ErlangParser.Instance) {
            ErlangParser.Instance = new ErlangParser();
        }
        return ErlangParser.Instance;
    }
    private Release = () => {
        if (this.buf != null) {
            this.buf = null;
            this.cur_pos = this.buf_len = 0;
            this.main_list.Release();
        }
    };
    private IsWhiteSpace = (val) => {
        return val == " " || val == "\t" || val == "\n" || val == "\r";
    };
    private SkipWhiteSpace = () => {
        while (this.cur_pos < this.buf_len && this.IsWhiteSpace(this.buf.charAt(this.cur_pos)))
            this.cur_pos++;
        if (this.cur_pos >= this.buf_len)
            return true;
        else
            return false;
    };
    private IsContainedInList = (buf: String) => {
        let len = buf.length;
        let tmp_buf: String = buf;
        let cur_pos = 0;
        while (cur_pos < len && this.IsWhiteSpace(tmp_buf.charAt(cur_pos)))
            cur_pos++;
        if (cur_pos <= len && tmp_buf.charAt(cur_pos) == "[")
            return true;
        return false;
    };
    private IsIdentityChar = (val) => {
        return this.identityCharParttern.test(val)
        // if (this.IsNumber(val) || this.IsLetter(val) || val == "_" || val == "." || val == "-")
        //     return true;
        // return false;
    };
    private IsNumber = (val) => {
        return val >= "0" && val <= "9";
    };
    private IsLetter = (val) => {
        return (val >= "a" && val <= "z") || (val >= "A" && val <= "Z");
    };
    public Parse = (buf) => {
        this.Release();
        let buf_len = buf.length;
        if (!this.IsContainedInList(buf)) {
            this.buf_len = buf_len + 2;
            this.buf = `[${buf}]`;
        }
        else {
            this.buf_len = buf_len;
            this.buf = buf;
        }
        if (this.SkipWhiteSpace())
            return;
        this.ParseArrayStatement(this.main_list);
        let tbl = this.ErListToArray(this.main_list);
        return tbl[0];
    };
    public parse = (buf) => {
        this.Release();
        let buf_len = buf.length;
        if (!this.IsContainedInList(buf)) {
            this.buf_len = buf_len + 2;
            this.buf = `[${buf}]`;
        }
        else {
            this.buf_len = buf_len;
            this.buf = buf;
        }
        if (this.SkipWhiteSpace())
            return;
        this.ParseArrayStatement(this.main_list);
        let tbl = this.ErListToArray(this.main_list);
        return tbl[0];
    };
    private ParseArrayStatement = (list) => {
        if (this.SkipWhiteSpace())
            return;
        let loop_times = 0;
        let enterQuotes = false
        while (this.cur_pos < this.buf_len) {
            if (this.SkipWhiteSpace())
                return;
            ++loop_times;
            let b = this.buf.charAt(this.cur_pos);
            switch (b) {
                case "[":
                    let arr_item = new ErListItem();
                    arr_item.InitAsType(ErlangParser.ErListItemType.Array);
                    list.item_list.push(arr_item);
                    this.cur_pos++;
                    this.ParseArrayStatement(arr_item.data);
                    break;
                case "{":
                    let obj_item = new ErListItem();
                    obj_item.InitAsType(ErlangParser.ErListItemType.Obj);
                    list.item_list.push(obj_item);
                    this.cur_pos++;
                    this.ParseArrayStatement(obj_item.data);
                    break;
                case ",":
                    this.cur_pos++;
                    break;
                case SpecialCharKey.ErlangParser1:
                    if (!enterQuotes) {
                        this.cur_pos++;
                        break;
                    } else {
                        enterQuotes = false
                    }
                case "]":
                case "}":
                    this.cur_pos++;
                    return;
                default:
                    let cur_item = new ErListItem();
                    cur_item.InitAsType(ErlangParser.ErListItemType.DataType);
                    list.item_list.push(cur_item);
                    cur_item.data = this.ParseDataItemStatement();
                    break;
            }
            if (loop_times > 1000) {
                GameError.GetInstance().SendErrorToPHP("erlangParser ParseArrayStatement loop times over 1000 " + this.buf);
                return;
            }
        }
    };
    private ParseDataItemStatement = () => {
        if (this.SkipWhiteSpace())
            return;
        let id_end_pos = this.cur_pos;
        while (id_end_pos < this.buf_len && this.IsIdentityChar(this.buf.charAt(id_end_pos))) {
            id_end_pos++;
        }
        let data = this.buf.substring(this.cur_pos, id_end_pos);
        this.cur_pos = id_end_pos;
        return data;
    };
    private GetMainList = () => {
        return this.main_list;
    };
    private ErListToObj = (list) => {
        let tbl = {};
        for (let k = 0; k < list.item_list.length; k++) {
            let item = list.item_list[k];
            switch (item.item_type) {
                case ErlangParser.ErListItemType.Array:
                    tbl[k] = this.ErListToArray(item.data);
                    break;
                case ErlangParser.ErListItemType.Obj:
                    tbl[k] = this.ErListToObj(item.data);
                    break;
                case ErlangParser.ErListItemType.DataType:
                    tbl[k] = item.data;
                    break;
            }
        }
        return tbl;
    };
    private ErListToArray = (list) => {
        let tbl = [];
        let len = list.item_list.length;
        for (let k = 0; k < len; k++) {
            let item = list.item_list[k];
            switch (item.item_type) {
                case ErlangParser.ErListItemType.Array:
                    tbl.push(this.ErListToArray(item.data));
                    break;
                case ErlangParser.ErListItemType.Obj:
                    tbl.push(this.ErListToObj(item.data));
                    break;
                case ErlangParser.ErListItemType.DataType:
                    tbl.push(item.data);
                    break;
            }
        }
        return tbl;
    };
}

window["ErlangParser"] = ErlangParser