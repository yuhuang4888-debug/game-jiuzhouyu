import { TalkBoard } from '../scene/sceneboard/TalkBoard';

export class MainUIStrongerTalkBoard extends TalkBoard {
    content_conta: Laya.Box;
    content_bg: Laya.Image;
    content: Laya.Label;
    htmlContentCache;
    htmlContent: Laya.HTMLDivElement;
    constructor(parent) {
        super(parent);
        this.base_file = 'mainStronger';
        this.layout_file = 'MainUIStrongerTalkBoard';
    }
    public InitData(id: any, content: any, res_height: any, pos: any, time: any, not_change_height?: any): void {
        super.InitData(id, content, res_height, pos, time, not_change_height);
        this.htmlContentCache = this.content_cache;
        this.content_cache = null;
    }
    protected LoadSuccess(): void {
        super.LoadSuccess();
        this.content.visible = false;
        this.htmlContent.style.color = '#98521a';
        this.htmlContent.style.fontSize = 20;
        this.htmlContent.style.bold = true;
        this.htmlContent.style.wordWrap = true;
        this.htmlContent.style.align = 'center';
        this.htmlContent.style.valign = 'middle';
    }
    public SetContent(content: string): void {
        content = content.replace('<br/>', '\n');
        this.htmlContentCache = content;
        if (!this.is_loaded) {
            this.needRefresh = true;
            return;
        }
        this.SetVisible(true);
        this.htmlContent.innerHTML = this.htmlContentCache;
        this.htmlContent.width = 190;
        let bg_offset = 50
        let bg_height = this.htmlContent.contextHeight + bg_offset;
        let width = bg_offset + this.htmlContent.contextWidth;
        this.content_bg.width = width > 230 ? 230 : width;
        this.content_bg.height = bg_height > 60 ? bg_height : 60;
        this.content_bg.y = - (this.content_bg.height - 59);
        
        this.content_conta.x = - (this.content_bg.width - 200)
        this.htmlContent.x = this.content_bg.width / 2 - this.htmlContent.contextWidth / 2;
        this.htmlContent.y = this.content_bg.y + ((this.content_bg.height - 5) / 2 - this.htmlContent.contextHeight / 2);
    }
    public GetComponents() {
        [this.content_conta, this.content_bg, this.content, this.htmlContent] = this.GetChildrenByNames(['content_conta', 'content_bg', 'content', 'htmlContent']);
    }
}
window['MainUIStrongerTalkBoard'] = MainUIStrongerTalkBoard;
