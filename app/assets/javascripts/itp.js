// @ts-check

/**
 * Sets up handling ITP (https://webkit.org/blog/7675/intelligent-tracking-prevention/)
 * via the storage access API (see https://webkit.org/blog/8124/introducing-storage-access-api/,
 * https://developer.mozilla.org/en-US/docs/Web/API/Storage_Access_API).
 * We need to do this in order to be able to access our cookies when in an iframe,
 * especially when spaces use a custom domain. Safari, and increasingly other browsers,
 * block cookies without this.
 * For this to work, we need an element (usually link or button) that will log the user in, i.e.
 * it will trigger the OAuth flow.
 * If the user has already been approved to access storage, the element will be clicked automatically.
 * If not, the user will have to click the element, which will result in this 
 * script requesting storage access and then clicking the element to trigger OAuth.
 * 
 * 
 * @param {HTMLElement} continueElement 
 */
function setupItp(continueElement) {
  if (document.hasStorageAccess) {
    document.hasStorageAccess().then(function (hasAccess) {
      if (hasAccess) {
        triggerContinue();
      }
    });
  }

  continueElement.addEventListener('click', function (e) {
    if (continueElement.dataset.skipStorageApi) {
      return;
    }
    if (document.requestStorageAccess) {
      e.preventDefault();
      document.requestStorageAccess().then(
        function successful() {
          triggerContinue();
        },
        function fail() {
          console.warn('Storage Access API call failed...');
        }
      );
    }
  });

  function triggerContinue() {
    continueElement.dataset.skipStorageApi = 'true';
    continueElement.click();
  }
}