import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LuaSoundManager } from '../common/SoundManager';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { PlatformManager } from '../PlatformManager';
import { Message } from '../sysInfo/SysInfoController';
import { Util } from '../util/Util';

export class GuildBoardView extends BaseView1 {
    board_content = '';
    board_limit = 40;
    is_center = true;
    use_background = true;
    click_bg_toClose = true;
    show_open_movie = true;
    destroy_imm = true;
    model: GuildModel;
    platformMgr: PlatformManager;

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildBoardView';
        this.layer_value = Enum_UILayer.Top;
        this.platformMgr = PlatformManager.GetInstance();
        this.model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.board_limit = this.model.GetGuildKVCfg(3);
            this.LoadSuccess();
            this.InitEvent();
        };

        this.destroy_callback = () => {
            this.Clear();
        };
    }

    InputChanged() {
        this._lb_limit.text = this._edit_text.text.length + '/' + this.board_limit;
    }

    public Open(...new_args) {
        this.board_content = new_args[0];
        super.Open();
    }

    public DeleteMe() {
        this._edit_text.off(Laya.Event.INPUT, this, this.InputChanged);
        super.DeleteMe();
    }

    Clear() {}

    LoadSuccess() {
        this._edit_text.maxChars = this.board_limit;
        this._edit_text.text = this.board_content;
        this._edit_text.multiline = false
        //this._lb_limit.text = this.board_content.length + "/" + this.board_limit
        this.InputChanged();

        // this._edit_text.onValueChanged.AddListener(() => {
        // 	this._lb_limit.text = this._edit_text.textl.length + "/" + this.board_limit
        // })
        this._edit_text.on(Laya.Event.INPUT, this, this.InputChanged);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_go,
            () => {
                //this.model.announce = this._edit_text.text
                let msg = this._edit_text.text;
                if (this.board_content == msg) {
                    this.Close();
                    return;
                }
                if (msg != null && msg.length == 0) {
                    Message.show('公告内容为空');
                    return;
                }
                let filter_callback = (is_filter) => {
                    if (is_filter) {
                        Message.show('内容有敏感词');
                        return;
                    }
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40012, 'cs', 2, msg);
                    this.Close();
                };
                Util.HasFilterWord(msg, null, filter_callback, 2);
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_close,
            () => {
                this.Close();
            },
            this,
            true,
            null,
            null,
            null,
            null,
            LuaSoundManager.SOUND_UI.CLOSE
        );
    }

    _Image111: Laya.Image;
    _Image4: Laya.Image;
    _Group1: Laya.Box;
    _Image5: Laya.Image;
    _Image6: Laya.Image;
    Placeholder: Laya.Label;
    Text1: Laya.Label;
    _btn_go: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_close: Laya.Box;
    _Image11: Laya.Image;
    _edit_text: Laya.TextInput;
    Text: Laya.Label;
    _lb_limit: Laya.Label;
    Image: Laya.Image;
    public GetComponents() {
        [this._Image111, this._Image4, this._Group1, this._Image5, this._Image6, this.Placeholder, this.Text1, this._btn_go, this._Image1, this.labelDisplay, this._btn_close, this._Image11, this._edit_text, this._lb_limit, this.Image] = this.GetChildrenByNames(['_Image111', '_Image4', '_Group1', '_Image5', '_Image6', 'Placeholder', 'Text1', '_btn_go', '_Image1', 'labelDisplay', '_btn_close', '_Image11', '_edit_text', '_lb_limit', 'Image']);
    }
}

window['GuildBoardView'] = GuildBoardView;
