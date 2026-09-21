document.addEventListener('DOMContentLoaded', () => {
  const TOOLTIP_ID = 'footnote-tooltip';
  const GAP = 8;
  const EDGE = 8;
  const MAX_WIDTH = 480;
  const OPEN_DELAY = 120;

  const refs = document.querySelectorAll('a[data-footnote-ref]');
  if (refs.length === 0) return;
  if (!window.matchMedia('(hover: hover)').matches) return;

  let tip = null;
  let current = null;
  let openTimer = 0;

  const ensureTip = () => {
    if (tip) return tip;
    tip = document.createElement('div');
    tip.id = TOOLTIP_ID;
    tip.className = 'footnote-tooltip';
    tip.setAttribute('role', 'tooltip');
    tip.hidden = true;
    document.body.appendChild(tip);
    return tip;
  };

  const buildContent = (ref) => {
    const href = ref.getAttribute('href') || '';
    if (href.charAt(0) !== '#') return null;
    let id;
    try { id = decodeURIComponent(href.slice(1)); } catch (e) { id = href.slice(1); }
    if (!id) return null;

    const scope = ref.closest('.article') || document;
    let li;
    try { li = scope.querySelector('#' + CSS.escape(id)); } catch (e) { return null; }
    if (!li) return null;

    const clone = li.cloneNode(true);
    clone.querySelectorAll('[data-footnote-backref]').forEach((el) => el.remove());
    clone.removeAttribute('id');
    clone.querySelectorAll('[id]').forEach((el) => el.removeAttribute('id'));
    return clone;
  };

  const place = (ref) => {
    const rect = ref.getBoundingClientRect();
    const vw = document.documentElement.clientWidth;
    const vh = window.innerHeight;

    tip.style.maxWidth = Math.min(MAX_WIDTH, vw - EDGE * 2) + 'px';

    const w = tip.offsetWidth;
    const h = tip.offsetHeight;

    const below = (rect.bottom + GAP + h <= vh) || (rect.top - GAP - h < 0);
    const top = below ? rect.bottom + GAP : rect.top - GAP - h;

    let left = rect.left + rect.width / 2 - w / 2;
    left = Math.max(EDGE, Math.min(left, vw - w - EDGE));

    tip.style.top = (top + window.scrollY) + 'px';
    tip.style.left = (left + window.scrollX) + 'px';
  };

  const show = (ref) => {
    const content = buildContent(ref);
    if (!content) return;
    ensureTip();
    tip.replaceChildren(...content.childNodes);
    tip.classList.remove('is-visible');
    tip.hidden = false;
    place(ref);
    tip.classList.add('is-visible');
    current = ref;
    ref.setAttribute('aria-describedby', TOOLTIP_ID);
  };

  const hide = () => {
    window.clearTimeout(openTimer);
    if (current) current.removeAttribute('aria-describedby');
    current = null;
    if (!tip || tip.hidden) return;
    tip.classList.remove('is-visible');
    tip.hidden = true;
    tip.replaceChildren();
  };

  refs.forEach((ref) => {
    ref.addEventListener('pointerenter', (e) => {
      if (e.pointerType === 'touch') return;
      window.clearTimeout(openTimer);
      openTimer = window.setTimeout(() => show(ref), OPEN_DELAY);
    });
    ref.addEventListener('pointerleave', (e) => {
      if (e.pointerType === 'touch') return;
      hide();
    });
    ref.addEventListener('focus', () => {
      let keyboard = true;
      try { keyboard = ref.matches(':focus-visible'); } catch (e) { keyboard = true; }
      if (keyboard) show(ref);
    });
    ref.addEventListener('blur', hide);
    ref.addEventListener('click', hide);
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') hide();
  });

  let ticking = false;
  const reposition = () => {
    if (!current || !tip || tip.hidden || ticking) return;
    ticking = true;
    window.requestAnimationFrame(() => {
      ticking = false;
      if (current && tip && !tip.hidden) place(current);
    });
  };
  window.addEventListener('scroll', reposition, { passive: true });
  window.addEventListener('resize', reposition);
});
